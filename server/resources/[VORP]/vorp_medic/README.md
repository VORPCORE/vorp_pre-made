# **VORP MEDIC Script**

This is a medic system for RedM using the VORP framework. It integrates various doctor-related functionalities, such as an on-duty system, shared/private storages, job management, and more. The script is designed for small to large servers and offers customization options to suit different server needs.

---

## **Installation**

1. Download or clone the repository to your server's resources folder.
2. Add `ensure vorp_medic` to your `server.cfg` file to ensure the script is loaded when the server starts.
3. Make sure the required dependencies are installed and properly configured.

## **Features**

### **Storage System**:
- Supports **shared** and **private** storages for doctor officers.
- Configurable item limits, allowing for a flexible inventory management system within the doctor force.

### **On-Duty System**:
- Utilize **statebags** to track whether players are on or off duty.

### **Teleport System**:
- Set up teleport points for **fast travel** between different doctor stations or key locations.
- Useful for both small and large servers, allowing for quick responses and movement across the map.

### **Boss Menu**:
- **Hire and fire players** via the boss menu, offering easy job management for doctor chiefs or higher-ranking officers.
- Simple and intuitive menu with all the necessary functionalities for managing the doctor force.

---

## **Dependencies**

This script requires the following VORP resources to function properly:

- **[VORP Core](https://github.com/VORPCORE/vorp_core-lua)**: Provides essential functions and event handlers used throughout the script.
- **[VORP Inventory](https://github.com/VORPCORE/vorp_inventory-lua)**: Manages the item-based inventory system, including cuffs and keys.
- **[VORP Menu](https://github.com/VORPCore/vorp_menu)**: Powers the interactive menu system, used for the boss menu, hire/fire system, and teleportation points.

Ensure you have these resources installed and correctly set up for the `vorp_medic` script to work seamlessly.

---

## **Usage**

1. **Storage**: Officers can access shared or private storage depending on configuration.
2. **On-Duty**: Use commands or menu options to go on or off duty.
3. **Teleport**: Teleports can be configured for quick travel between key locations.
4. **Boss Menu**: Manage the doctor force by hiring and firing players directly through the boss menu.

---

## **Configuration**

You can configure the script to suit your server's needs. The following settings can be adjusted in the configuration file:

- **Storage Settings**: Define limits for shared or private storage, and enable/disable features like weapon storage.
- **Duty Settings**: Customize the duty system, including state management.
- **Job Labels**: Add or modify doctor job labels for hire/fire functionality.
- **Teleport Locations**: Set up teleport points for doctor stations or other important areas on the map.

---

## **Support and Updates**

For support or further information please ask in the [Vorp Core discord](https://discord.gg/JjNYMnDKMf)
. Updates will be released periodically to improve functionality or compatibility with the latest VORP framework versions.
