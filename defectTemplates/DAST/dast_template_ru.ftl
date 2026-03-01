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
<h3>Информация об объекте сканирования:</h3>
<#assign firstIssue=issues?sort_by(['lastScan','date'])?reverse[0]>
<#if firstIssue.lastScan.scanTarget?size != 0>
    <table>
        <#list firstIssue.lastScan.scanTarget as target>
            <@tableRowIfParamIsNotEmptyDateTime name="Дата сканирования" param=firstIssue.lastScan.date?datetime/>
            <@tableRowIfParamIsNotEmptyIdName name="Объект сканирования" param1=firstIssue.scanObject.id param2=firstIssue.scanObject.name />
            <@tableRowIfParamIsNotEmptyString name="Ветка" param=target.branch/>
            <@tableRowIfParamIsNotEmptyString name="Коммит" param=target.commit/>
            <@tableRowIfParamIsNotEmptyString name="Версия" param=target.version/>
            <@tableRowIfParamIsNotEmptyString name="Сборка" param=target.build/>
            <@tableRowIfParamIsNotEmptyString name="URL объекта" param=target.url/>
        </#list>
        <@tableRowIfParamIsNotEmptyString name="Инициатор" param=firstIssue.lastScan.initiator/>
        <@tableRowIfParamIsNotEmptyString name="Окружение" param=firstIssue.lastScan.environment/>
    </table>
<#else>
    <#assign scanObject=firstIssue.scanObject>
    <table>
        <@tableRowIfParamIsNotEmptyIdName name="Объект сканирования" param1=scanObject.id param2=scanObject.name/>
    </table>
</#if>

<h3>Сводка по уязвимостям:</h3>
<#if issues?size gt 1>
    <table>
        <tr>
            <th>ID</th>
            <th>Расположение</th>
            <th>Серьёзность</th>
            <th>Инструмент</th>
        </tr>

        <#list issues?sort_by("severity") as issue>
            <tr>
                <td><@linkOrText href=issue.link text=issue.id/></td>
                <td>${issue.title}</td>
                <td>${issue.severity}</td>
                <td><@linkOrText href=issue.externalLink text=issue.foundBy/></td>
            </tr>
        </#list>
    </table>
</#if>
<#if issues?size == 1>
    <#list issues as issue>
        <p>ID: <@linkOrText href=issue.link text=issue.id/></p>
        <p>Расположение: ${issue.title}</p>
        <p>Серьёзность: ${issue.severity}</p>
        <p>Инструмент: <@linkOrText href=issue.externalLink text=issue.foundBy/></p>
    </#list>
</#if>

<h3>Детальная информация по уязвимостям:</h3>
<table>
    <tr>
        <th>ID</th>
        <th>Описание</th>
    </tr>
    <#list issues?sort_by("severity") as issue>
        <tr>
            <td><@linkOrText href=issue.link text=issue.id/></td>
            <td>${issue.description}</td>
        </tr>
    </#list>
</table>