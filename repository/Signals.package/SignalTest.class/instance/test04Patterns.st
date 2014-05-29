tests
test04Patterns

	consumer connect: producer signal: #valueChanged: toSelector: #toggleSwitch pattern: #().
	
	self assert:#off equals: consumer switchState.	
	producer value: 'as'.
	self assert:#on equals: consumer switchState.	