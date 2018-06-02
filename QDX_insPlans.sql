select insPlanCode, insPlanNames, insPlanCategory, insPlanType, insPlanInactive,
insPlanElectronicElig, insPlanEligID,
insPlanPreClaimCat, 
insPlanCompany, insPlanPayorID,
insPlanClmStatIDDesc
from Quadax.dbo.insPlans
where insPlanCompany != 'Roster'
/* Excluded Roster records */