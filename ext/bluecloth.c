/* 
 * BlueCloth -- a Ruby implementation of Markdown
 * $Id$
 * 
 * = Authors
 * 
 * - Michael Granger <ged@FaerieMUD.org>
 * 
 * BlueCloth 2 is mostly just a wrapper around the Discount library
 * written by David Loren Parsons <http://www.pell.portland.or.us/~orc>. 
 *
 * = License
 * 
 * Discount:
 * Copyright (C) 2007 David Loren Parsons. All rights reserved.
 * 
 * The Discount library is used under the licensing terms outlined in the
 * COPYRIGHT.discount file included in the distribution.
 * 
 * Ruby bits:
 * See the LICENSE file included in the distribution.
 * 
 */

#include "mkdio.h"
#include "ruby.h"

VALUE bluecloth_cBlueCloth;
VALUE bluecloth_default_opthash;


/* Get a Discount document for the specified text */
static MMIOT *
bluecloth_alloc( VALUE text ) {
	MMIOT *document;
	
	document = mkd_string( RSTRING_PTR(text), RSTRING_LEN(text), 0 );
	if ( !document ) rb_sys_fail( RSTRING_PTR(text) );
	
	return document;
}


/*
 * GC Free function
 */
static void 
bluecloth_gc_free( MMIOT *document ) {
	if ( document ) {
		mkd_cleanup( document );
		document = NULL;
	}
}


/* --------------------------------------------------------------
 * Utility functions
 * -------------------------------------------------------------- */

#ifdef HAVE_STDARG_PROTOTYPES
#include <stdarg.h>
void
bluecloth_debug(const char *fmt, ...)
#else
#include <varargs.h>
void
bluecloth_debug( fmt, va_alist )
	 const char *fmt;
	 va_dcl
#endif
{
	char buf[BUFSIZ], buf2[BUFSIZ];
	va_list	args;

	if (!RTEST(ruby_debug)) return;

	snprintf( buf, BUFSIZ, "Debug>>> %s", fmt );

#ifdef HAVE_STDARG_PROTOTYPES
	va_start( args, fmt );
#else
	va_start( args );
#endif
	vsnprintf( buf2, BUFSIZ, buf, args );
	fputs( buf2, stderr );
	fputs( "\n", stderr );
	fflush( stderr );
	va_end( args );
}


/*
 * Object validity checker. Returns the data pointer.
 */
static MMIOT *
bluecloth_check_ptr( VALUE self ) {
	Check_Type( self, T_DATA );

    if ( !rb_obj_is_kind_of(self, bluecloth_cBlueCloth) ) {
		rb_raise( rb_eTypeError, "wrong argument type %s (expected BlueCloth object)",
				  rb_class2name(CLASS_OF( self )) );
    }
	
	return DATA_PTR( self );
}


/*
 * Fetch the data pointer and check it for sanity.
 */
static MMIOT *
bluecloth_get_ptr( VALUE self ) {
	MMIOT *ptr = bluecloth_check_ptr( self );

	if ( !ptr )
		rb_fatal( "Use of uninitialized BlueCloth object" );

	return ptr;
}


/* --------------------------------------------------------------
 * Class methods
 * -------------------------------------------------------------- */

/*
 *  call-seq:
 *     BlueCloth.allocate   -> object
 *
 *  Allocate a new BlueCloth object.
 *
 */
static VALUE
bluecloth_s_allocate( VALUE klass ) {
	return Data_Wrap_Struct( klass, NULL, bluecloth_gc_free, 0 );
}


/*
 *  call-seq:
 *     BlueCloth.discount_version   -> string
 *
 *  Return the version string of the Discount library BlueCloth was built on.
 *
 */
static VALUE
bluecloth_s_discount_version( VALUE klass ) {
	return rb_str_new2( markdown_version );
}

/* --------------------------------------------------------------
 * Instance methods
 * -------------------------------------------------------------- */

/*
 *  call-seq:
 *     BlueCloth.new( string='', options=DEFAULT_OPTIONS )   -> object
 *
 * Create a new BlueCloth object that will process the given +string+. The +options+ 
 * argument is a Hash that can be used to control the generated markup, and to 
 * enable/disable extensions. See the documentation for DEFAULT_OPTIONS for the
 * available settings.
 * 
 */
static VALUE 
bluecloth_initialize( int argc, VALUE *argv, VALUE self ) {
	if ( !bluecloth_check_ptr(self) ) {
		MMIOT *document;
		VALUE text, textcopy, optflags, fullhash, opthash = Qnil;

		rb_scan_args( argc, argv, "02", &text, &opthash );

		/* Default empty string and options */
		if ( argc == 0 ) {
			text = rb_str_new( "", 0 );
		}

		/* One arg could be either the text or the opthash, so shift the args if appropriate */
		else if ( argc == 1 && (TYPE(text) == T_HASH || TYPE(text) == T_FIXNUM) ) {
			opthash = text;
			text = rb_str_new( "", 0 );
		}

		/* Merge the options hash with the defaults and turn it into a flags int */
		if ( NIL_P(opthash) ) opthash = rb_hash_new();
		optflags = rb_funcall( bluecloth_cBlueCloth, rb_intern("flags_from_opthash"), 1, opthash );
		fullhash = rb_funcall( bluecloth_cBlueCloth, rb_intern("opthash_from_flags"), 1, optflags );

		DATA_PTR( self ) = document = bluecloth_alloc( text );
		if ( !mkd_compile(document, NUM2INT(optflags)) )
			rb_raise( rb_eRuntimeError, "Failed to compile markdown" );

		textcopy = rb_str_dup( text );
		OBJ_FREEZE( textcopy );
		rb_iv_set( self, "@text", textcopy );
		OBJ_FREEZE( fullhash );
		rb_iv_set( self, "@options", fullhash );

		OBJ_INFECT( self, text );
	}

	return self;
}


/*
 *  call-seq:
 *     bluecloth.to_html   -> string
 *
 *  Transform the document into HTML.
 *
 */
static VALUE
bluecloth_to_html( VALUE self ) {
	MMIOT *document = bluecloth_get_ptr( self );
	char *output;
	int length;
	VALUE result = Qnil;

	bluecloth_debug( "Compiling document %p", document );
	
	if ( (length = mkd_document( document, &output )) != EOF ) {
		bluecloth_debug( "Pointer to results: %p, length = %d", output, length );
		result = rb_str_new( output, length );

		OBJ_INFECT( result, self );
		return result;
	} else {
		return Qnil;
	}
}




/* --------------------------------------------------------------
 * Initializer
 * -------------------------------------------------------------- */

void Init_bluecloth_ext( void ) {
	bluecloth_cBlueCloth = rb_define_class( "BlueCloth", rb_cObject );

	rb_define_alloc_func( bluecloth_cBlueCloth, bluecloth_s_allocate );
	rb_define_singleton_method( bluecloth_cBlueCloth, "discount_version", 
		bluecloth_s_discount_version, 0 );

	rb_define_method( bluecloth_cBlueCloth, "initialize", bluecloth_initialize, -1 );

	rb_define_method( bluecloth_cBlueCloth, "to_html", bluecloth_to_html, 0 );
	
	rb_define_attr( bluecloth_cBlueCloth, "text", 1, 0 );
	rb_define_attr( bluecloth_cBlueCloth, "options", 1, 0 );
	
	/* --- Constants ----- */
	/* special flags for markdown() and mkd_text() */
	rb_define_const( bluecloth_cBlueCloth, "MKD_NOLINKS", INT2FIX(MKD_NOLINKS) );
	rb_define_const( bluecloth_cBlueCloth, "MKD_NOIMAGE", INT2FIX(MKD_NOIMAGE) );
	rb_define_const( bluecloth_cBlueCloth, "MKD_NOPANTS", INT2FIX(MKD_NOPANTS) );
	rb_define_const( bluecloth_cBlueCloth, "MKD_NOHTML",  INT2FIX(MKD_NOHTML) );
	rb_define_const( bluecloth_cBlueCloth, "MKD_STRICT",  INT2FIX(MKD_STRICT) );
	rb_define_const( bluecloth_cBlueCloth, "MKD_TAGTEXT", INT2FIX(MKD_TAGTEXT) );
	rb_define_const( bluecloth_cBlueCloth, "MKD_NO_EXT",  INT2FIX(MKD_NO_EXT) );
	rb_define_const( bluecloth_cBlueCloth, "MKD_CDATA",   INT2FIX(MKD_CDATA) );
	rb_define_const( bluecloth_cBlueCloth, "MKD_TOC",     INT2FIX(MKD_TOC) );
	rb_define_const( bluecloth_cBlueCloth, "MKD_EMBED",   INT2FIX(MKD_EMBED) );

	/* special flags for mkd_in() and mkd_string() */
	rb_define_const( bluecloth_cBlueCloth, "MKD_NOHEADER", INT2FIX(MKD_NOHEADER) );
	rb_define_const( bluecloth_cBlueCloth, "MKD_TABSTOP",  INT2FIX(MKD_TABSTOP) );

	/* Make sure the Ruby side is loaded */
	rb_require( "bluecloth" );

	bluecloth_default_opthash = rb_const_get( bluecloth_cBlueCloth, rb_intern("DEFAULT_OPTIONS") );
}

