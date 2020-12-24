
// 0 for debug, 1 for testing, 2 for prod
int debugTestingProd = 0;
bool isMockingServer = debugTestingProd == 0 || debugTestingProd == 1;
String testsOutputFileNm = 'communication_output.txt';
String testsOutputFile = 'test/communication_output.txt';