directorydir = $(datadir)/desktop-directories

directory_in_files =    		    \
	AudioVideo.directory.in			\
	Development.directory.in		\
	Education.directory.in			\
	Game.directory.in			    \
	Graphics.directory.in			\
	Network.directory.in			\
	Office.directory.in			    \
	Settings.directory.in           \
	System-Tools.directory.in		\
	Utility.directory.in

directory_DATA = $(directory_in_files:.directory.in=.directory)

@INTLTOOL_DIRECTORY_RULE@

EXTRA_DIST = $(directory_in_files)
DISTCLEANFILES = $(directory_DATA)
