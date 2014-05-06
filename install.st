Transcript cr; show: 'travis---->bootstrapMetacello.st'.

"Bootstrap Metacello-Base to simulate conditions when it's included in base images"
[(Smalltalk
  at: #'MetacelloProject'
  ifAbsent: []) 
    ifNil: [
      "Metacello not pre-installed install Metacello-Base"
      Transcript cr; show: 'Metacello not pre-installed install Metacello-Base'.
      MetacelloBuilderTravisCI fileIn: 'Metacello-Base.st'.

      "ensure that Gofer is available on Squeak"
      MetacelloBuilderTravisCI retry: [
        (Smalltalk at: #ConfigurationOf) 
          ensureGoferVersion: 'Gofer-Core-lr.115' 
          repositoryUrl: 'http://seaside.gemtalksystems.com/ss/metacello'. ]]
    ifNotNil: [
      "MetacelloProject already installed, install Metacello Preview"
      Smalltalk 
        at: #Metacello
        ifAbsent: [
          "Metacello class not present, so let's bootstrap the Metacello Preview"
          Transcript cr; show: 'Metacello pre-installed bootstrap Metacello Preview'.
          MetacelloBuilderTravisCI retry: [
            (Smalltalk at: #Gofer) new
              url: 'http://seaside.gemtalksystems.com/ss/metacello';
              package: 'ConfigurationOfMetacello';
              load ].
          ((Smalltalk at: #ConfigurationOfMetacello) project 
            version: #'previewBootstrap') load ].
      Transcript cr; show: 'Install stable version of Metacello Preview'.
      (Smalltalk at: #Metacello) new
        configuration: 'MetacelloPreview';
        version: #'stable'; 
        repository: 'github://dalehenrich/metacello-work:configuration';
        get.
      (Smalltalk at: #Metacello) new
        configuration: 'MetacelloPreview';
        version: #'stable'; 
        repository: 'github://dalehenrich/metacello-work:configuration';
        load ]] 
	on: Warning
	do: [:ex |
		Transcript cr; show: 'Warning: ', ex description.
		ex resume: true].

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

(Installer monticello http: 'http://seaside.gemtalksystems.com/ss/')
    project: 'metacello';
            install: 'ConfigurationOfMetacello'.
                    (Smalltalk at: #ConfigurationOfMetacello) perform: #load.

"How do we find the actual repository? It's _by definition_ BUILD_DIR."
source := (Smalltalk at: #MCFileTreeRepository) path: ((Smalltalk at: #UnixProcess) env at: #'BUILD_DIR').
packages := source allPackageNames.
packages := #('BaselineOfSignals' 'SI-Benchmarks' 'SI-OB-Morphic' 'SI-Reflection' 'SI-Wrapper' 'Signals').

"Load in the latest versions (for filetree there ought to be only one version
 per package)."
packages do: [:pkg |
    (source highestNumberedVersionForPackageNamed: pkg) load].

"Load in any configurations found. There OUGHT to be only one...?"
((packages select: [:pkg |
    pkg startsWith: 'ConfigurationOf'])
        collect: #asSymbol)
            do: [:conf |
                log value: 'Installing ', conf.
                (Smalltalk at: conf) loadStable].

baseDir := FileDirectory on: ((Smalltalk at: #UnixProcess) env at: #'BUILD_DIR').
(baseDir fileOrDirectoryExists: 'install.st')
    ifTrue: [ |loader|
        loader := CodeLoader new.
	baseDir fileNamed: 'install.st' do: [:f |
            loader installSourceFile: f]].

WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
