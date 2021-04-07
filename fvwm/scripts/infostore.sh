#! /bin/bash
# Add infostore items from gsettings

SCHEMAS=(ydesk.common ydesk.fonts ydesk.apps ydesk.applets)

for sch in ${SCHEMAS[@]}; do
    for key in $(gsettings list-keys $sch); do
        val=$(gsettings get $sch $key)
        echo "InfoStoreAdd $key $val"
    done
done

