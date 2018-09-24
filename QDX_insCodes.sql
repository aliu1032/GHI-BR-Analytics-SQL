/* unique insCode */
select insCO QDXInsCoName, insCode QDXInsCode, insDesc QDXInsName, insAltId Tier4PayorID
, case 
  when insFC = 'PVT' then 'COMM'
  when insFC in ('MCAD','MCR', 'PBLC') then 'GOVT'
  else insFC
  end as QDXInsFC
, insInsType QDXInsLOBenefit
FROM [Quadax].[dbo].[insCodes]
where insType = 'CD'
and insAltId like 'PL%'
and insAltId in (select insAltId
			     from Quadax.dbo.insCodes
				 where insType = 'CD'
				 and insAltId like 'PL%'
				 group by insAltId
				 having count(insAltId) = 1
				 )

Union

/* duplicate insCode */
select QDXInsCoName, QDXInsCode, QDXInsName, Tier4PayorID, QDXInsFC, QDXInsLOBenefit
from
(
	Select rowNum = row_number() over (partition by insAltId order by insCo, insFC desc), 
	insCO QDXInsCoName, insCode QDXInsCode, insDesc QDXInsName, insAltId Tier4PayorID
	, case 
	  when insFC = 'PVT' then 'COMM'
	  when insFC in ('MCAD','MCR', 'PBLC') then 'GOVT'
	  else insFC
	  end as QDXInsFC
	, insInsType QDXInsLOBenefit
	from Quadax.dbo.insCodes
	where insType = 'CD'
	and insAltId like 'PL%'
	and insAltId in (select insAltId
				     from Quadax.dbo.insCodes
					 where insType = 'CD'
					 and insAltId like 'PL%'
					 group by insAltId
					 having count(insAltId) > 1
					 )
) A
where rowNum = 1