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
            <th>Файл</th>
            <th>Серьёзность</th>
            <th>Инструмент</th>
            <th>Категория</th>
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
            <p>Файл: ${issue.path[0].fileName}:${issue.path[0].line}</p>
        </#if>
        <p>Серьёзность: ${issue.severity}</p>
        <p>Инструмент: <a href="${issue.externalLink}">${issue.foundBy}</a></p>
        <p>Категория: ${issue.category}</p>
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
            <td><a href="${issue.link}">${issue.id}</a></td>
            <td><th>Трасса</th><br>
                <#list issue.path as item>
                    ${item.fileName}:${item.line}<br><code>${item.sourceCode?html}</code><#sep><br></#sep>
                </#list>
                <br>
                <p>Описание</p><br>
                ${issue.description}
            </td>
        </tr>
    </#list>
</table>
