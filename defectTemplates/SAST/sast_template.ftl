<#macro tableRowIfParamIsNotEmptyString name param>
    <#if param!="">
        <tr>
            <th>${name}</th>
            <td>${param}</td>
        </tr>
    </#if>
</#macro>
<#macro tableRowIfParamIsNotEmptyDateTime name param>
    <#if param??>
        <tr>
            <th>${name}</th>
            <td>${param}</td>
        </tr>
    </#if>
</#macro>
<#macro tableRowIfParamIsNotEmptyIdName name param1 param2>
    <#if param1?? && param2!="">
        <tr>
            <th>${name}</th>
            <td>#${param1}: ${param2}</td>
        </tr>
    </#if>
</#macro>
<h3>Scan target info:</h3>
<#assign firstIssue=issues?sort_by(['lastScan','date'])?reverse[0]>
<#if firstIssue.lastScan.scanTarget?size != 0>
    <table>
        <#list firstIssue.lastScan.scanTarget as target>
            <@tableRowIfParamIsNotEmptyDateTime name="Scan date" param=firstIssue.lastScan.date?datetime/>
            <@tableRowIfParamIsNotEmptyIdName name="Scan target" param1=firstIssue.scanObject.id param2=firstIssue.scanObject.name />
            <@tableRowIfParamIsNotEmptyString name="Branch" param=target.branch/>
            <@tableRowIfParamIsNotEmptyString name="Commit" param=target.commit/>
            <@tableRowIfParamIsNotEmptyString name="Version" param=target.version/>
            <@tableRowIfParamIsNotEmptyString name="Build" param=target.build/>
            <@tableRowIfParamIsNotEmptyString name="Target URL" param=target.url/>
        </#list>
        <@tableRowIfParamIsNotEmptyString name="Initiator" param=firstIssue.lastScan.initiator/>
        <@tableRowIfParamIsNotEmptyString name="Environment" param=firstIssue.lastScan.environment/>
    </table>
<#else>
    <#assign scanObject=firstIssue.scanObject>
    <table>
            <@tableRowIfParamIsNotEmptyIdName name="Scan target" param1=scanObject.id param2=scanObject.name/>
    </table>
</#if>

<h3>Issues brief info:</h3>
<#if issues?size gt 1>
    <table>
        <tr>
            <th>ID</th>
            <th>File</th>
            <th>Severity</th>
            <th>Tool</th>
            <th>Category</th>
        </tr>

        <#list issues?sort_by("severity") as issue>
            <tr>
                <td><a href="${issue.link}">${issue.id}</a></td>
                <#if issue.path?size gt 0>
                    <td>${issue.path[0].fileName}:${issue.path[0].line}</td>
                </#if>
                <td>${issue.severity}</td>
                <td><a href="${issue.externalLink}">${issue.foundBy}</a></td>
                <td>${issue.category}</td>
            </tr>
        </#list>
    </table>
</#if>
<#if issues?size == 1>
    <#list issues as issue>
        <p>ID: <a href="${issue.link}">${issue.id}</a></p>
        <#if issue.path?size gt 0>
            <p>File: ${issue.path[0].fileName}:${issue.path[0].line}</p>
        </#if>
        <p>Severity: ${issue.severity}</p>
        <p>Tool: <a href="${issue.externalLink}">${issue.foundBy}</a></p>
        <p>Category: ${issue.category}</p>
    </#list>
</#if>

<h3>Issues detailed info:</h3>
<table>
    <tr>
        <th>ID</th>
        <th>Description</th>
    </tr>
    <#list issues?sort_by("severity") as issue>
        <tr>
            <td><a href="${issue.link}">${issue.id}</a></td>
            <td><p><b>Path</b></p>
                <ul>
                    <#list issue.path as item>
                        <li>
                            <p>${item.fileName}:${item.line}
                            <p><code>${item.sourceCode?html}</code>
                            <#sep><p></#sep>
                        </li>
                    </#list>
                </ul>
                <p><b>Description</b></p>
                ${issue.description}
            </td>
        </tr>
    </#list>
</table>
