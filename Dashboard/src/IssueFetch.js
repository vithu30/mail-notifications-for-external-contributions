// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied. See the License for the
// specific language governing permissions and limitations
// under the License.

import React from 'react';
import {Component} from 'react';
import {BootstrapTable, TableHeaderColumn} from 'react-bootstrap-table';
import {TacoTable, DataType, SortDirection} from 'react-taco-table';
import './react-taco-table.css';
// import './react-bootstrap-table.min.css';
import './react-bootstrap-table-all.min.css';
import './App.css';
import $ from 'jquery';

const summaryColoumn = [
    {
        id: 'productName',
        type: DataType.String,
        header: 'Product',
    },
    {
        id: 'Total',
        type: DataType.Number,
        header: 'Number of Issues',
    },
];
const options = {
    clearSearch: true,
    defaultSortName: 'Days',
    defaultSortOrder: 'desc'
};
const urlNavigation = (cell) => {
    let link = `${cell}`;
    return (
        <a href = {link} target = "_blank">
            {link}
        </a>
    )
};
var config = require('./config.json');

// const url = config.issueUrl;
// const summaryUrl = config.summaryOfIssueUrl;

const url = 'https://identity-gateway.cloud.wso2.com/t/wso2internal928/ext-pr-issues/issues';
const summaryUrl = 'https://identity-gateway.cloud.wso2.com/t/wso2internal928/ext-pr-issues/issueSummary';

class issueData extends Component{
    constructor(props){
        super(props);
        this.state = {
            data : [],
            summary : [],
        }
    }
    componentWillMount() {
        $.ajax({
            url: url,
            dataType: 'json',
            context:this,
            type: 'GET'
        }).done(function (result) {
            this.setState({
                data : result
            })
        })

        $.ajax({
            url: summaryUrl,
            context: this,
            dataType: 'json',
            type: 'GET'
        }).done(function (summaryResult) {
            this.setState({
                summary : summaryResult
            })
        })
    }

    // componentDidMount() {
    //     fetch(url)
    //         .then((issues) => issues.json())
    //         .then((jsonIssues) =>
    //             {
    //                 console.log(jsonIssues);
    //                 this.setState({
    //                     data : jsonIssues,
    //                 })
    //             }
    //         );
    //     fetch(summaryUrl)
    //         .then((summary) => summary.json())
    //         .then((jsonSummary) =>
    //             {
    //                 console.log(jsonSummary);
    //                 this.setState({
    //                     summary : jsonSummary,
    //                 })
    //             }
    //         );
    // }
    render() {
        return(
            <div>
                <div className = "summaryTable">
                    <TacoTable
                        initialSortDirection = { SortDirection.Ascending }
                        initialSortColumnId = "Total"
                        columns = { summaryColoumn }
                        data = { this.state.summary }
                        striped />
                </div>
                <BootstrapTable
                    data = {this.state.data}
                    striped = {true}
                    bordered = { false }
                    dataAlign = "center"
                    pagination search = { true }
                    options = { options } >
                    <TableHeaderColumn
                        width = '20%'
                        dataField = "product"
                        isKey = { true }
                        dataSort = { true } >
                        Product
                    </TableHeaderColumn>
                    <TableHeaderColumn
                        width = '15%'
                        dataField = "RepositoryName"
                        dataSort = { true } >
                        Repository
                    </TableHeaderColumn>
                    <TableHeaderColumn
                        ref = 'url'
                        width = '30%'
                        dataField = "Url"
                        dataSort = { true }
                        dataFormat = { urlNavigation } >
                        Url
                    </TableHeaderColumn>
                    <TableHeaderColumn
                        width = '15%'
                        dataField = "githubId"
                        dataSort = { true } >
                        Github Id
                    </TableHeaderColumn>
                    <TableHeaderColumn
                        width = '10%'
                        dataField = "Days"
                        dataSort = { true } >
                        Open days
                    </TableHeaderColumn>
                    <TableHeaderColumn
                        width = '10%'
                        dataField = "Weeks"
                        dataSort = { true } >
                        Open Weeks
                    </TableHeaderColumn>
                </BootstrapTable>
            </div>
        )
    }
}
export default issueData;
