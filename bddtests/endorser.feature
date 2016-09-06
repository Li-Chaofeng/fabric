  #
# Test Endorser function
#
# Tags that can be used and will affect test internals:
#  @doNotDecompose will NOT decompose the named compose_yaml after scenario ends.  Useful for setting up environment and reviewing after scenario.
#  @chaincodeImagesUpToDate use this if all scenarios chaincode images are up to date, and do NOT require building.  BE SURE!!!

#@chaincodeImagesUpToDate
@endorser
Feature: Endorser
    As a application developer
    I want to get endorsements and submit transactions and receive events

    Scenario: Peers list test, single peer issue #827
        Given we compose "docker-compose-1.yml"
        When requesting "/network/peers" from "vp0"
        Then I should get a JSON response with array "peers" contains "1" elements

#    @doNotDecompose
    @FAB-184
	Scenario Outline: Basic deploy endorsement for chaincode through GRPC to multiple endorsers

	    Given we compose "<ComposeFile>"
        And I wait "1" seconds
        And I register with CA supplying username "binhn" and secret "7avZQLwcUe9q" on peers:
          | vp0  |

        When user "binhn" creates a chaincode spec of type "GOLANG" for chaincode "github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02" aliased as "cc_spec" with args
             | funcName | arg1 |  arg2 | arg3 | arg4 |
             |   init   |  a   |  100  |  b   |  200 |
        And user "binhn" creates a deployment proposal "proposal1" using chaincode spec "cc_spec"
        And user "binhn" sends proposal "proposal1" to endorsers with timeout of "2" seconds:
          | vp0  | vp1 | vp2 |  vp3  |
        And user "binhn" stores their last result as "proposal1Responses"
        Then user "binhn" expects proposal responses "proposal1Responses" with status "200" from endorsers:
          | vp0  | vp1 | vp2 |  vp3  |


    Examples: Orderer Options
        |          ComposeFile                 |    Waittime   |
        |   docker-compose-next-4.yml          |       60      |


#    @doNotDecompose
    @FAB-314
	Scenario Outline: Advanced deploy endorsement with ESCC for chaincode through GRPC to single endorser

	    Given we compose "<ComposeFile>"
        And I register with CA supplying username "binhn" and secret "7avZQLwcUe9q" on peers:
          | vp0  |

        When user "binhn" creates a chaincode spec of type "GOLANG" for chaincode "github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02" aliased as "cc_spec" with args
             | funcName | arg1 |  arg2 | arg3 | arg4 |
             |   init   |  a   |  100  |  b   |  200 |
        And user "binhn" sets ESCC to "my_escc" for chaincode spec "cc_spec"
        And user "binhn" creates a deployment proposal "proposal1" using chaincode spec "cc_spec"
        And user "binhn" sends proposal "proposal1" to endorsers with timeout of "2" seconds:
          | vp0  | vp1 | vp2 |  vp3  |
        And user "binhn" stores their last result as "proposal1Responses"
        Then user "binhn" expects proposal responses "proposal1Responses" with status "200" from endorsers:
          | vp0  | vp1 | vp2 |  vp3  |

    Examples: Orderer Options
        |          ComposeFile           |    Waittime   |
        |   docker-compose-next-4.yml    |       60      |

#    @doNotDecompose
    @FAB-314
	Scenario Outline: Advanced deploy endorsement with VSCC for chaincode through GRPC to single endorser

	    Given we compose "<ComposeFile>"
        And I register with CA supplying username "binhn" and secret "7avZQLwcUe9q" on peers:
          | vp0  |

        When user "binhn" creates a chaincode spec of type "GOLANG" for chaincode "github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02" aliased as "cc_spec" with args
             | funcName | arg1 |  arg2 | arg3 | arg4 |
             |   init   |  a   |  100  |  b   |  200 |
        And user "binhn" sets VSCC to "my_vscc" for chaincode spec "cc_spec"
        And user "binhn" creates a deployment proposal "proposal1" using chaincode spec "cc_spec"
        And user "binhn" sends proposal "proposal1" to endorsers with timeout of "2" seconds:
          | vp0  | vp1 | vp2 |  vp3  |
        And user "binhn" stores their last result as "proposal1Responses"
        Then user "binhn" expects proposal responses "proposal1Responses" with status "200" from endorsers:
          | vp0  | vp1 | vp2 |  vp3  |

    Examples: Orderer Options
        |          ComposeFile           |    Waittime   |
        |   docker-compose-next-4.yml    |       60      |

