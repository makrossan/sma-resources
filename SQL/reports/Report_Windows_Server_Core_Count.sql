-- ============================================================================
-- Report Name: Windows Server – CPU Core Count (with Total)
-- Version:     Compatible with KACE SMA v14.1 (Tested and Verified)
-- Author:      Greivin Venegas
-- ============================================================================
-- Description:
-- This SQL report is designed to help system administrators determine
-- the total number of physical CPU cores across all machines running
-- Windows Server in the environment.

-- Use Case:
-- Licensing Windows Server requires knowing the number of physical CPU cores.
-- For example, if an admin manages a cluster with 4 physical servers,
-- and each has a CPU with 16 cores, they must purchase licenses
-- that cover 64 cores in total.

-- Purpose:
-- This report extracts each Windows Server machine from the KACE SMA database,
-- parses the number of CPU cores from the PROCESSORS field,
-- and summarizes all hardware data including manufacturer, model, IP, MAC, and serial.

-- The last row in the report provides a grand total of all detected CPU cores.

-- Assumptions:
-- - Machines already have Windows Server OS installed.
-- - The data source is the "PROCESSORS" inventory field, which includes
--   a "CPU Core Count" line from the agent's inventory scan.

-- Notes:
-- - No additional joins are used.
-- - Tested and working as expected on KACE SMA version 14.1.

-- Adjustments:
-- - The query is not restricted by label, but this could be added later
--   if filtering is needed.
-- ============================================================================
SELECT
  NAME,
  PROCESSORS,
  IP,
  MAC,
  CSP_ID_NUMBER AS Serial,
  CS_MANUFACTURER AS Manufacturer,
  CS_MODEL AS Model,
  CHASSIS_TYPE,
  CAST(
    SUBSTRING_INDEX(
      SUBSTRING_INDEX(PROCESSORS, 'CPU Core Count: ', -1),
      '\n', 1
    ) AS UNSIGNED
  ) AS Core_Count
FROM MACHINE
WHERE OS_NAME LIKE '%Windows Server%'

UNION ALL

SELECT
  'Total' AS NAME,
  '' AS PROCESSORS,
  '' AS IP,
  '' AS MAC,
  '' AS Serial,
  '' AS Manufacturer,
  '' AS Model,
  '' AS CHASSIS_TYPE,
  SUM(
    CAST(
      SUBSTRING_INDEX(
        SUBSTRING_INDEX(PROCESSORS, 'CPU Core Count: ', -1),
        '\n', 1
      ) AS UNSIGNED
    )
  ) AS Core_Count
FROM MACHINE
WHERE OS_NAME LIKE '%Windows Server%';