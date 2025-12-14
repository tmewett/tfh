package require Tk

oo::class create app {
    variable iDir
    variable viewingDir
    constructor {} {
        grid [ttk::button .up -text "Up" -command "[self] upClicked"]
        grid [ttk::treeview .tree]
        .tree tag bind clickable <ButtonPress> "[self] itemClicked %W"
        set iDir [pwd]
        set viewingDir ""
    }
    method itemClicked {path} {
        puts $path
    }
    method upClicked {} {
        set iDir [file dirname $iDir]
        my update
    }
    method update {} {
        if {$iDir != $viewingDir} {
            cd $iDir
            set files [glob *]
            .tree children {} {}
            foreach file $files {
                .tree insert {} end -text $file -tags [list clickable]
            }
            set $viewingDir $iDir
        }
    }
}

set appO [app new]
$appO update

tkwait window .
