
import ballerina.log;
import ballerina.collections;
import org.WSO2.Ballerina;

public function main (string[] args) {
    log:printInfo("Prgram initiated");
    collections:Vector reposVector = Ballerina:getRepositories();
    Ballerina:getPullRequests(reposVector);
    Ballerina:getIssues(reposVector);
    Ballerina:writeRawData();
    Ballerina:updateProductTable(Ballerina:getProductComponentData());
}
