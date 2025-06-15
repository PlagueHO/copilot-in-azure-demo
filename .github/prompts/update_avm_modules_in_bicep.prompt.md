---
mode: 'agent'
description: 'Update the Azure Verified Module to the latest version for the Bicep infrastructure as code file.'
tools: ['changes', 'codebase', 'editFiles', 'extensions', 'fetch', 'findTestFiles', 'githubRepo', 'new', 'openSimpleBrowser', 'problems', 'runCommands', 'runNotebooks', 'runTasks', 'search', 'searchResults', 'terminalLastCommand', 'terminalSelection', 'testFailure', 'usages', 'vscodeAPI', 'filesystem', 'create_directory', 'directory_tree', 'edit_file', 'get_file_info', 'list_allowed_directories', 'list_directory', 'read_file', 'read_multiple_files', 'search_files', 'write_file', 'move_file']
---
Your goal is to update the Bicep file `${file}` to use the latest available versions of Azure Verified Modules (AVM).
You will need to perform these steps:
1. Get a list of all the Azure Verified Modules that are used in the specific `${file}` Bicep file and get the module names and their current versions.
2. Step through each module referenced in the Bicep file and find the latest version of the module. Do this by fetching the tags list from Microsoft Container Registry. E.g. for 'br/public:avm/res/compute/virtual-machine' fetch [https://mcr.microsoft.com/v2/bicep/avm/res/compute/virtual-machine/tags/list](https://mcr.microsoft.com/v2/bicep/avm/res/compute/virtual-machine/tags/list) and find the latest version tag. The latest version is the highest number in the list of tags.
3. If there is a newer version of the module available than is currently used in the Bicep, fetch the documentation for the module from the Azure Verified Modules index page. E.g., for `br/public:avm/res/compute/virtual-machine` the docs are [https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/compute/virtual-machine](https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/compute/virtual-machine)
4. Update the Azure Verified Module in the Bicep file to use the latest available version and apply any relevant changes to the module parameters based on the documentation.
5. If there are no changes to the module, leave it as is.

Ensure that the Bicep file is valid after the changes and that it adheres to the latest standards for Azure Verified Modules and there are no linting errors.
