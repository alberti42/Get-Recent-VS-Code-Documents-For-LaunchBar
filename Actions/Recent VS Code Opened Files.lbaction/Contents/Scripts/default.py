#!/usr/bin/env -S -P/usr/local/bin:${PATH} python3
# coding: utf-8
#
# LaunchBar Action Script

import json
import os

JSON_PATH = "~/Library/Application Support/Code/User/globalStorage/storage.json"

def create_main_item(item_path):
    return dict(title = os.path.basename(item_path), subtitle = os.path.dirname(item_path),path = item_path)

# Define the path to the storage.json file
storage_json_path = os.path.expanduser(JSON_PATH)

items = []

# Open and load the JSON file
try:
    try:
        with open(storage_json_path, 'r') as file:
            data = json.load(file)
    except Exception as e:
        raise RuntimeError(f"Error in opening the .json file: {e}")

    # Access 'lastKnownMenubarData -> menus -> File -> items' field
    try:
        file_menu_items = data['lastKnownMenubarData']['menus']['File']['items']
    except Exception as e:
        raise RuntimeError("Error in finding 'file' items the .json file")

    # Find the first item where the 'id' is 'submenuitem.MenubarRecentMenu'
    recent_menu = next((item for item in file_menu_items if item.get('id') == 'submenuitem.MenubarRecentMenu'), None)

    if recent_menu and 'submenu' in recent_menu and 'items' in recent_menu['submenu']:
        # Iterate over the items
        for item in recent_menu['submenu']['items']:
            if(item.get('id')=='openRecentFile'):
                if('uri' in item and 'path' in item['uri']):
                    filepath = item['uri']['path']
                    items.append(create_main_item(filepath))
    else:
        raise RuntimeError("Error in finding 'submenu' items in the .json file")
except Exception as e:
    items = []

print(json.dumps(items))

