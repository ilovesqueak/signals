SimpleButtonMorph subclass: #GHPushButton
                     instanceVariableNames: 'hasRequested'
                     classVariableNames: ''
                     poolDictionaries: ''
                     category: 'Github'!
!GHPushButton methodsFor: 'button'!
doButtonAction
    hasRequested ifFalse: [
        | user pass store |
        OSProcess waitForCommand: 'git config credential.helper "store --file=/tmp/credentials"'.
        user := FillInTheBlank request: 'Github username?'.
        pass := FillInTheBlank requestPassword: 'Github password?'.
        store := FileStream fileNamed: '/tmp/credentials'.
        store nextPutAll: 'https://' , user , ':' , pass , '@github.com'.
        hasRequested := true.
    ].
    OSProcess waitForCommand: 'git push'.
! !
!GHPushButton methodsFor: 'initialization'!
initialize 
    hasRequested := false.
    super initialize.
! !
| baseDir log source packages |

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

log value: 'Installing Metacello'.
(Smalltalk at: #Gofer) new
              url: 'http://seaside.gemtalksystems.com/ss/metacello';
                            package: 'ConfigurationOfMetacello';
                                          load.
((Smalltalk at: #ConfigurationOfMetacello) project
            version: #'previewBootstrap') load.

log value: 'Installing Metacello-work'.
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

log value: 'Installing Signals'.
(Smalltalk at: #Metacello) new
  baseline: 'Signals';
  repository: 'filetree:///repository';
  get.

(Smalltalk at: #Metacello) new
  baseline: 'Signals';
  repository: 'filetree:///repository';
  load.
log value: 'Done'.
(GHPushButton new initializeWithLabel: 'Publish on Github.') openInWorld.!
!MCVersionInfo methodsFor: 'accessing'!
date
    ^ date.! !
!MCVersionInfo methodsFor: 'accessing'!
time
    ^ time.! !
