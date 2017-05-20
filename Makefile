#
#   Thomas Russel Carrel
#
#   Makefile
#
#   Define DEBUG, by uncommenting the last argument in CXXFLAGS, will
#  enable detailed debug out put.
#   
#   All of these compile lines are set up to duplicate all output (errors) 
#  from g++ and copy it into a file.
#
###############################################################################
###############################################################################
#
#  Set variables.
#
###############################################################################
CXX = g++
CXX_VERS := $(shell g++ -dumpversion)
OS_VERS := $(shell g++ -dumpmachine)

AUTHOR := Thomas R. Carrel

#SDL2_CFLAGS := $(shell sdl2-config --cflags)

GCCERREXT = gccerr

#  This executable name was chose because it was short... a more appropriate one
# should be chosen later.
MAIN = gg

ERROR_DIR = ./Errors
ENTRY_POINT_DIR = entry_point

DOXY_OUTPUT_DIR = $(ERROR_DIR)/Doxygen

OBJ_FILES = .entry_point.o

COPYOUTPUT = 2>&1 | tee $(ERROR_DIR)/_$@.$(GCCERREXT)
COPYDOXYOUTPUT = 2>&1 | tee $(ERROR_DIR)/$@.doxy.out

#LIBS = -

COMPILER_ID = -D COMPILER_ID_STRING="$(CXX_VERS)"
OS_ID = -D OS_ID_STRING="$(OS_VERS)"
AUTHOR_ID = -D AUTHOR_ID_STRING="$(AUTHOR)"
DATE = -D COMPILE_TIME="$(shell date)"
COLOR = -D COLOR_ARRAY
CLEAR_ARGS = -D CLEAR_ARGS

INFO = $(COMPILER_ID) $(OS_ID) $(AUTHOR_ID) $(DATE) $(COLOR) $(CLEAR_ARGS)


#CXXFLAGS = $(SDL2_CFLAGS) -time -Wall -g -std=c++11 -D TIMED -D DEBUG \
#		   -D GLEW_STATIC -O0
CXXFLAGS = $(SDL2_CFLAGS) -time -Wall -g -std=c++11 -D TIMED -D DEBUG \
		   -D GLEW_STATIC -O0 $(INFO)
###############################################################################
#
#  The adjacency list.
#
###############################################################################

# link
$(MAIN): $(OBJ_FILES) $(ERROR_DIR) Makefile
	$(CXX) $(CXXFLAGS) $(OBJ_FILES) -o $@ \
		2>&1 | tee $(ERROR_DIR)/$@.$(GCCERREXT)


.entry_point.o: $(ENTRY_POINT_DIR)/entry_point.cpp $(ERROR_DIR)
	$(TIME) $(CXX) $(CXXFLAGS) -c $< -o $@ $(COPYOUTPUT)


$(ERROR_DIR):
	mkdir -p $@

# compile App namespace.
#.entry_point.o: $(APP_DIR)/entry_point.cpp $(APP_DIR)/app.h constants.h \
#		$(SHADER_HEADER) $(APP_ERROR_DIR)
#	$(TIME) $(CXX) $(CXXFLAGS) $(INFO) -c $< -o $@ $(COPYOUTPUT)

#.entry_point.o: $(APP_DIR)/entry_point.cpp $(APP_DIR)/app.h constants.h \
#		$(SHADER_HEADER) $(APP_ERROR_DIR)
#	$(TIME) $(CXX) $(CXXFLAGS) -c $< -o $@ $(COPYOUTPUT)

# clean
clean:
	rm -f .*.o $(MAIN) a.out
	rm -rf $(ERROR_DIR)
	rm -rf $(DOC_DIR)

# compile documentation.
doc: Doxyfile $(ALL_FILES_IN_PROJECT) $(DOC_DIR) $(MAIN) $(DOXY_OUTPUT_DIR)
	doxygen $(COPYDOXYOUTPUT)

$(DOC_DIR):
	mkdir -p $@

$(DOXY_OUTPUT_DIR): $(ERROR_DIR)
	mkdir -p $@

###############################################################################
#
#  Grouped commands.
#
###############################################################################

all: Main doc

Main: $(MAIN)
