SUBDIRS = icons fdo menu utils misc settings theme

gsettings_SCHEMAS = ydesk.gschema.xml

.PRECIOUS: $(gsettings_SCHEMAS)

@GSETTINGS_RULES@

EXTRA_DIST = $(gsettings_SCHEMAS)
