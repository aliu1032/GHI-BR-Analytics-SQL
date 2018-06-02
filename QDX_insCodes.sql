select insType, insCode, insDesc, insAltId, insInsType, insFC, insDefAdj, insCO
FROM [Quadax].[dbo].[insCodes]
where insType = 'CD'
and insAltId like 'PL%'
order by insCode desc