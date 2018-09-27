import ballerina.io;

import org.wso2.contributions_from_outsiders;
import ballerina.collections;


public function main (string[] args) {
    //string [] orgs = ["ballerinax", "ballerina-platform","wso2-ballerina"];
    //contributions_from_outsiders:deleteEntries();
    //foreach org in orgs  {
    //    collections:Vector reposVector = contributions_from_outsiders:getRepositories(org);
    //    contributions_from_outsiders:getPullRequests(reposVector,org);
    //    contributions_from_outsiders:getIssues(reposVector,org);
    //}
    //contributions_from_outsiders:writeRawData();
    
    contributions_from_outsiders:generateMailBody();
}
