/*
 * configuration for markdown, generated Tue Dec 23 06:19:25 PST 2008
 * by ged@tenar.home.faeriemud.org
 */

#ifndef CONFIG_H_RZLE3ADO
#define CONFIG_H_RZLE3ADO

#ifdef HAVE_SRANDOM
#	define INITRNG(x) srandom((unsigned int)x)
#elif  HAVE_SRAND
#	define INITRNG(x) srand((unsigned int)x)
#else
#	define INITRNG(x) (void)1
#endif

#ifdef HAVE_STRCASECMP
#elif  HAVE_STRICMP
#	define strcasecmp stricmp
#endif

#ifdef HAVE_STRNCASECMP
#elif  HAVE_STRNICMP
#	define strncasecmp strnicmp
#endif

#ifdef HAVE_RANDOM
#	define COINTOSS() (random()&1)
#elif  HAVE_RAND
#	define COINTOSS() (rand()&1)
#else
#	define COINTOSS() 1
#endif

#define TABSTOP 4
#undef USE_AMALLOC

/* Extensions */
#define SUPERSCRIPT 1
#define RELAXED_EMPHASIS 1
#define DIV_QUOTE 1
#define DL_TAG_EXTENSION 1
#define PANDOC_HEADER 1
#define ALPHA_LIST 1

#endif /* end of include guard: CONFIG_H_RZLE3ADO */

