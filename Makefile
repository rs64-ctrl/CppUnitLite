INSTALL   = install -c
MKDIR     = mkdir -p
PREFIX    = /usr/local
LIBDIR    = $(PREFIX)/lib
INCDIR    = $(PREFIX)/include/CppUnitLite
AR        = ar
RM        = rm -f
CC        = g++
CPPFLAGS  = -g -O2 -Wall -ICppUnitLite
LDFLAGS   = 

SOURCES   = $(wildcard src/*.cpp)
OBJECTS   = $(patsubst src/%.cpp,%.o,$(SOURCES))
INCTARGET = $(wildcard CppUnitLite/*.h)
LIBTARGET = libCppUnitLite.a

all : $(LIBTARGET)

%.o: src/%.cpp
	$(CC) -c $< -o $@ $(CPPFLAGS)

$(LIBTARGET): $(OBJECTS)
	$(AR) -cq $@ $^

%.d: src/%.cpp
	$(CC) -M $(CPPFLAGS) $< > $@.$$$$; \
	sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
	rm -f $@.$$$$

-include $(patsubst src/%.cpp,%.d,$(SOURCES))

clean:
	$(RM) $(patsubst src/%.cpp,%.d,$(SOURCES))
	$(RM) $(OBJECTS)

distclean: clean
	$(RM) $(LIBTARGET)

install: all
	$(MKDIR) $(LIBDIR)
	$(INSTALL) $(LIBTARGET) $(LIBDIR)
	$(MKDIR) $(INCDIR)
	$(INSTALL) $(INCTARGET) $(INCDIR)

uninstall:
	rm -f $(LIBDIR)/$(LIBTARGET)
	@for h in $(notdir $(INCTARGET)); do \
		rm -f $(INCDIR)/$$h; \
	done
	-rmdir $(LIBDIR)
	-rmdir $(INCDIR)
