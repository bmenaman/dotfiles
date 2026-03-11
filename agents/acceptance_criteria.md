Generally just run all tests with make

tasks should always be testable tasks are never complete until a test verifies them.  Choose the best kind of test from the following in order of precedence (best to worst):
1. a feature test covers the change and passes
2. a unit test covers the change and passes
3. the code runs and validates the change
4. the code builds
5. lint or other kinds of static validation
6. bash commands that determine something exists
7. asking the user to review the code.