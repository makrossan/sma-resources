-- ============================================================================
-- Report Name: Service Desk - All queues - Unassigned active tickets
-- Version:     Compatible with KACE SMA v14.1 (Tested and Verified)
-- Author:      Greivin Venegas
-- ============================================================================
-- Description:
--   Lists all unassigned Service Desk tickets across all queues, excluding
--   statuses "Closed" and "Process Complete". Shows ID, Title, Queue, Owner, Status.
--
--   The report assumes administrators are working with statuses whose State is
--   "Closed" for "Closed" and "Process Complete". The State for a status determines
--   how the system handles tickets of this status. Any other status in the "Closed"
--   state is not considered in this report.
--
--   For more information about existing statuses and their state, go to:
--   Service Desk / Configuration / Queue Customization / Status
--   then update the report as needed.
--
-- Use Case:
--   Triage/dispatch board to identify tickets needing assignment across queues.
--   Daily monitoring of unassigned active workload and SLA risk.
--
-- Purpose:
--   Provide cross-queue visibility of unassigned, non-closed tickets for fast assignment.
--
-- Assumptions:
--   • Unassigned means OWNER_ID IS NULL or 0.
--   • Status names are exactly "Closed" and "Process Complete".
--   • Admin is responsible for adjusting for additional status in the state of "Closed" 
--   • Service Process status is shown only for parent tickets that use processes.
--   • Run as an SQL report not bound to a single queue.
--
-- Notes:
--   • Uses HAVING on computed STATUS_NAME to exclude terminal states.
--   • If your site localizes status names, exclude by state instead of name.
--
-- Adjustments:
--   • Limit to specific queues: add  AND Q.NAME IN ('Queue A','Queue B').
--   • Date window (e.g., last 7 days): add  AND H.CREATED > DATE_SUB(NOW(), INTERVAL 7 DAY).
-- ============================================================================

SELECT
  H.ID,
  H.TITLE,
  Q.NAME AS QUEUE_NAME,
  O.FULL_NAME AS OWNER_NAME,
  IF(H.HD_USE_PROCESS_STATUS = 1 AND H.IS_PARENT = 1, SVC.NAME, ST.NAME) AS STATUS_NAME
FROM HD_TICKET H
JOIN HD_QUEUE Q
  ON Q.ID = H.HD_QUEUE_ID
LEFT JOIN USER O
  ON O.ID = H.OWNER_ID
LEFT JOIN HD_SERVICE_STATUS SVC
  ON H.HD_USE_PROCESS_STATUS = 1
 AND H.HD_SERVICE_STATUS_ID = SVC.ID
LEFT JOIN HD_STATUS ST
  ON ST.ID = H.HD_STATUS_ID
WHERE (H.OWNER_ID IS NULL OR H.OWNER_ID = 0)
HAVING STATUS_NAME NOT IN ('Process Complete', 'Closed')
ORDER BY Q.NAME, H.ID;
