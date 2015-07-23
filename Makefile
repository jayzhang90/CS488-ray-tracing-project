SOURCES = $(wildcard *.cpp)
OBJECTS = $(SOURCES:.cpp=.o)
DEPENDS = $(SOURCES:.cpp=.d)
LDFLAGS = $(shell pkg-config --libs lua5.1) -llua5.1 -lpng
CPPFLAGS = $(shell pkg-config --cflags lua5.1)
CXXFLAGS = $(CPPFLAGS) -W -Wall -g
CXX = clang++
MAIN = rt


ifeq ($(shell uname), Darwin)
LDFLAGS = -L/usr/local/lib $(shell pkg-config --libs lua5.1) -llua -lpng
CPPFLAGS = -I/usr/local/include $(shell pkg-config --cflags lua5.1)
CXXFLAGS +=$(CPPFLAGS) -std=c++11 -W -Wall -Wno-unused-parameter -g -O1
endif

all: $(MAIN)

depend: $(DEPENDS)

clean:
	rm -f *.o *.d

$(MAIN): $(OBJECTS)
	@echo Creating $@...
	@$(CXX) -o $@ $(OBJECTS) $(LDFLAGS)

%.o: %.cpp
	@echo Compiling $<...
	@$(CXX) -o $@ -c $(CXXFLAGS) $<

%.d: %.cpp
	@echo Building $@...
	@set -e; $(CC) -M $(CPPFLAGS) $< \
                  | sed 's/\($*\)\.o[ :]*/\1.o $@ : /g' > $@; \
                [ -s $@ ] || rm -f $@

include $(DEPENDS)
