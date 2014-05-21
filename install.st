| baseDir log source packages gitPath |

log := [:msg | | str |
    str := '-----> ', msg.
    FileStream stdout nextPutAll: str; nextPut: Character lf; flush.
    Transcript cr; show: str].

log value: 'Installing filetree'.
Installer ss3
    project: 'FileTree';
    install: 'ConfigurationOfFileTree'.
((Smalltalk at: #ConfigurationOfFileTree) project version: '1.0') load.

log value: 'Installing OSProcess'.
Installer ss
    project: 'OSProcess';
    install: 'OSProcess-dtl.73'.

(Smalltalk at: #Gofer) new
              url: 'http://seaside.gemtalksystems.com/ss/metacello';
                            package: 'ConfigurationOfMetacello';
                                          load.
((Smalltalk at: #ConfigurationOfMetacello) project
            version: #'previewBootstrap') load.

(Smalltalk at: #Metacello) new
        configuration: 'MetacelloPreview';
                version: #'stable';
                        repository: 'github://dalehenrich/metacello-work:configuration';
                                get.

(Smalltalk at: #Metacello) new
        configuration: 'MetacelloPreview';
                version: #'stable';
                        repository: 'github://dalehenrich/metacello-work:configuration';
                                load.
gitPath := FileDirectory default fullName.

(Smalltalk at: #Metacello) new
  baseline: 'Signals';
  repository: 'github://hubx/signals:master/repository';
  get.

(Smalltalk at: #Metacello) new
  baseline: 'Signals';
  repository: 'github://hubx/signals:master/repository';
  load.
