<#macro linkOrText href text>
    <#if href!="">
        <a href="${href}">${text}</a>
    <#else>
        ${text}
    </#if>
</#macro>
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
            <th>Component</th>
            <th>Severity</th>
            <th>Tool</th>
            <th>Vulnerability</th>
            <th>Fix Version</th>
        </tr>

        <#list issues?sort_by("severity") as issue>
            <tr>
                <td><@linkOrText href=issue.link text=issue.id/></td>
                <td>${issue.title}</td>
                <td>${issue.severity}</td>
                <td><@linkOrText href=issue.externalLink text=issue.foundBy/></td>
                <td><@linkOrText href=issue.cve.link text=issue.cve.id/></td>
                <td><#if issue.fixVersion!="">${issue.fixVersion}<#else>No info</#if></td>
            </tr>
        </#list>
    </table>
</#if>
<#if issues?size == 1>
    <#list issues?sort_by("severity") as issue>
        <p>ID: <@linkOrText href=issue.link text=issue.id/></p>
        <p>Component: ${issue.title}</p>
        <p>Severity: ${issue.severity}</p>
        <p>Tool: <@linkOrText href=issue.externalLink text=issue.foundBy/></p>
        <p>Vulnerability: <@linkOrText href=issue.cve.link text=issue.cve.id/></p>
        <#if issue.fixVersion!=""><p>Fix version: ${issue.fixVersion}</p></#if>
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
            <td><@linkOrText href=issue.link text=issue.id/></td>
            <td>${issue.description}</td>
        </tr>
    </#list>
</table>