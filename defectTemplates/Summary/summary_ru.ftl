<#assign issue=issues?sort_by("severity")[0]>
${issue.severity?capitalize} ${issue.type} уязвимости в ${issue.scanObject.name}