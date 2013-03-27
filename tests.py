import unittest
import testsuite.blueprint_test as BT
import testsuite.unit_tests as UT

if __name__ == '__main__':
	print "Running test suite!\n"
	
	print "Running unit tests."
	suite = unittest.TestLoader().loadTestsFromTestCase(UT.crisTestCase)
	unittest.TextTestRunner(verbosity=2).run(suite)

	print "\nRunning blueprint tests."
	suite = unittest.TestLoader().loadTestsFromTestCase(BT.BlueprintTestCase)
	unittest.TextTestRunner(verbosity=2).run(suite)

	print "\nFinished running test suite!"
