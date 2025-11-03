# Monitor SMA with Zabbix using HOST-RESOURCES-MIB

This repository documents how to monitor **Quest KACE SMA (Systems Management Appliance)** via **SNMP** using Zabbix.
The focus here is on using the modern and standardized **HOST-RESOURCES-MIB**, instead of the outdated **RFC1213-MIB**.

---

## 🧩 Overview

In the past, many guides (including Quest’s own [KB 4337579](https://support.quest.com/kb/4337579/k1000-snmp-object-identifiers-oid-high-level-oids)) recommended **RFC1213-MIB** (`MIB-II`) to monitor SMA appliances.
That approach is now **deprecated ❌**.

Instead, use **HOST-RESOURCES-MIB ✅**, which provides richer, structured information about:

* Storage (disks, memory, swap, etc.)
* Process and system load
* Uptime and device identifiers

Reference: [HOST-RESOURCES-MIB on mibbrowser.online](https://mibbrowser.online/mibdb_search.php?mib=HOST-RESOURCES-MIB)

---

## 🧠 Discovering OIDs

You can use `snmpwalk` to browse available OIDs.
For example, to list all storage descriptions:

```bash
snmpwalk -v2c -c braziquenha 10.11.11.105 .1.3.6.1.2.1.25.2.3.1.3
```

**Sample output:**

```
HOST-RESOURCES-MIB::hrStorageDescr.1 = STRING: Physical memory
HOST-RESOURCES-MIB::hrStorageDescr.2 = STRING: Real memory
HOST-RESOURCES-MIB::hrStorageDescr.3 = STRING: Virtual memory
HOST-RESOURCES-MIB::hrStorageDescr.6 = STRING: Memory buffers
HOST-RESOURCES-MIB::hrStorageDescr.7 = STRING: Cached memory
HOST-RESOURCES-MIB::hrStorageDescr.10 = STRING: Swap space
HOST-RESOURCES-MIB::hrStorageDescr.31 = STRING: /kbox
HOST-RESOURCES-MIB::hrStorageDescr.33 = STRING: /
HOST-RESOURCES-MIB::hrStorageDescr.34 = STRING: /usr
HOST-RESOURCES-MIB::hrStorageDescr.37 = STRING: /var
```

Once you identify the index of the storage you want (for instance `/var` = index 37), you can query specific metrics.

---

## 📊 Example: Checking Usage

```bash
snmpwalk -v2c -c braziquenha 10.11.11.105 1.3.6.1.2.1.25.2.3.1.6.37
```

**Output:**

```
HOST-RESOURCES-MIB::hrStorageUsed.37 = INTEGER: 185234
```

That value corresponds to the number of allocation units used by `/var`.
In Zabbix, you can combine it with `hrStorageSize` and `hrStorageAllocationUnits` to calculate percentage usage.

---

## ⚙️ Zabbix Integration

1. Add your SMA as an SNMPv2 host in Zabbix.
2. Use the `HOST-RESOURCES-MIB` template or create custom items based on OIDs discovered via `snmpwalk`.
3. Monitor memory, swap, and filesystem usage reliably without relying on outdated MIBs.

---

## 🧾 References

* [Quest KACE KB 4337579 – Old RFC1213 MIB (deprecated)](https://support.quest.com/kb/4337579/k1000-snmp-object-identifiers-oid-high-level-oids)
* [RFC1213-MIB (deprecated)](https://mibbrowser.online/mibdb_search.php?mib=RFC1213-MIB)
* [HOST-RESOURCES-MIB (recommended)](https://mibbrowser.online/mibdb_search.php?mib=HOST-RESOURCES-MIB)

---

## 🚫 Deprecated Notice

The **RFC1213-MIB** method is no longer recommended, as it exposes limited information and lacks granularity compared to **HOST-RESOURCES-MIB**.
New deployments should always use **HOST-RESOURCES-MIB** for storage and memory monitoring.
