# BDD

## Glue A.K.A. Steps
e.g. `tests/bdd/**/*.py`
Typically the files should be organised in 3 layers:
the first should be a very thin wrapper  which exists to decouple the matcher annotations from the actual glue.  Typically methods will contain a single line of code.
the second is the real glue.  it will configure message to send and receive and control state (an instance of the application, ideally for each scenario). Consult the relevant documentation for the cucumber library to understand the use of fixtures
the third is use to construct mocks for the various dependencies where necessary. 
assertions should be grouped together.
Tests should be black box; they should use the public interfaces of the service.

 ## Feature Files
 Applies to `**/*.feature` files.  These should be written in plain business language. They should not include any software or related technical jargon.  They may include technical detail related to the business domain.  So for example, they would not mention Kafka or a socket but could refer to the mathematics of a rate calculation.  They should be terse. Do not include both Given and When if they do not have significant independent value.  Given should generally be some pre-requisite condition.  When should describe the action or event which happens.