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
        store nextPutAll: 'https://' , user , ':' , pass , '@github.com'; lf.
        hasRequested := true.
        OSProcess waitForCommand: 'git config --global user.name ', user
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

log value: 'Installing FileTree'.
Installer ss3
    project: 'FileTree';
    install: 'ConfigurationOfFileTree'.
((Smalltalk at: #ConfigurationOfFileTree) project version: '1.0') load.

log value: 'Installing OSProcess'.
Installer ss
    project: 'MetacelloRepository';
    install: 'ConfigurationOfOSProcess'.
(Smalltalk at: #ConfigurationOfOSProcess) project stableVersion load.

Installer monticello
  mc: (MCFileTreeRepository directory:
    (FileDirectory uri: '/repository'));
  install: 'Signals'.
log value: 'Done'.

(GHPushButton new initializeWithLabel: 'Publish on Github.') openInWorld.!
!MCVersionInfo methodsFor: 'accessing'!
date
    ^ date.! !
!MCVersionInfo methodsFor: 'accessing'!
time
    ^ time.! !
