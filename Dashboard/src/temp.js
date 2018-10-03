import React from 'react';
import ReactDOM from 'react-dom';
import Constant from './Constant';
import Util from './Util.js';

const HEADINGS = Constant.HEADINGS;

var formatDevelopersUtil = Util.formatDevelopers;


class TableData extends React.Component {

    constructor(props) {
        super();
        this.state = {
            changeSets: [
                {
                    id: "",
                    supportJira: "",
                    developers: "",
                    products: "",
                    escalationLevel: "",
                    lifeCycle: "",
                    addedTimestamp: ""
                }

            ],
            status: 0

        };

        //formatDevelopers = Util.formatDevelopers.bind(this);

        console.log("Constructor " + props);
    }

    mapEscalationList(data) {

        return data.map(function (change, index) {

            var people = change.people;
            return {
                id: change.id,
                supportJira: change.jiraId,
                developers: people,
                products: change.products,
                escalationLevel: change.escalationLevel,
                lifeCycle: change.lcState,
                addedTimestamp: change.addedTimestamp
            }

        });
    }

    componentWillMount() {
        $.ajax({
            url: '/escalation/escalations',
            context: this,
            dataType: 'json',
            type: 'GET'
        }).done(function (data) {
            var changeSets = this.mapEscalationList(data);

            this.setState({
                changeSets: changeSets
            });
        });
    }

    componentDidUpdate() {
        console.log("Component did update");
        this.props.handler();
    }

    formatDevelopers(developersList) {
        var formattedDevList = [];
        var developers = developersList.split(",");
        for (var i = 0; i < developers.length; i++) {
            formattedDevList.push(developers[i] + " ");
        }
        return formattedDevList;

    }

    render() {

        var formatDevelopers = this.formatDevelopers.bind(this);

        var headings = this.state.changeSets.map(function (name, index) {

            var devList = formatDevelopers(name.developers.toString());

            var classLabel = '';

            if (name.lifeCycle == LCStatus.open) {
                classLabel = 'escalation-open';
            } else if (name.lifeCycle == LCStatus.inProgress) {
                classLabel = 'escalation-in-progress';
            } else if (name.lifeCycle == LCStatus.closed) {
                classLabel = 'escalation-closed';
            }

            return (
                <tr key={index}>
                    <td width="15%">
                        <a target="_blank" href={'https://support.wso2.com/jira/browse/' + name.supportJira}>
                            {name.supportJira}
                        </a>
                    </td>
                    <td width="10%">{devList}</td>
                    <td>{name.products.toString()}</td>
                    <td>{name.escalationLevel}</td>
                    <td>
                        <span className={'label ' + classLabel}>{name.lifeCycle}</span>
                    </td>
                    <td>{name.addedTimestamp}</td>
                    <td>
                        <a className="btn btn-primary btn-sm" role="button" href={"/editEscalation/" + name.id}>Edit</a>
                    </td>
                </tr>);

        });

        return (<tbody>
        {headings}
        </tbody>);
    }


};


export default EscalationList;