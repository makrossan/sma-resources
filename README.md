## KACE SMA packages

This repository contains a curated collection of SQL queries, scripts, managed installations, and custom inventory rules specifically designed for **KACE Systems Management Appliance (SMA)**.

Each SQL query includes notes specifying its intended use case, such as:

- Custom Ticket Rules  
- SQL Reports  
- Smart Labels  
- Troubleshooting  
- Other Administrative Tasks  


## Compatibility

Each package includes:

- ✅ The SMA version it was created for  
- 🔄 Whether it has been tested or verified on newer versions  

This helps ensure proper usage in different environments.


## Import packages

1. Make sure "Enable file sharing" is enabled: Settings / Control Panel / Security Settings / Samba
2. ⁠⁠Setup a password. Note: username is admin
3. Paste the resources to SMB path:
	1. From Windows //<your-sma-ip>/clientdrop 
	2. From Linux smb://<your-sma-ip>/clientdrop 
4. Log in to the admin UI of the target SMA: https://<your-sma-ip>/admin
5. Go to Settings / Resources
6. In Choose Action, pick Import Resource(s) from Samba Share.
7. Tick the resources you want and click Import Resources.


## ⚠️ Disclaimer

All content in this repository is provided **"as is"** and is intended solely for **informational and educational purposes**.

It is strongly recommended to test any query, configuration, or script in a **lab environment** before applying it in production.

Some of the queries were partially assisted by AI tools. However, I have personally reviewed and modified each one as necessary to ensure relevance and accuracy. That said, complete accuracy of AI-assisted content cannot be guaranteed.

By accessing and using this repository, you agree that you are solely responsible for any outcomes resulting from the use of the provided information.


## Contributions

If you’d like to improve an existing query or contribute your own, feel free to open a **pull request** or **issue**. All contributions are welcome!
