# Marketplace VM Samples

This repo shows how to build a Virtual Machine for Linux or Windows and is limited to the
basic steps required to make that image ready for the Azure Marketplace. The images are placed into 
a [Shared Image Gallery](https://docs.microsoft.com/azure/virtual-machines/shared-image-galleries) for later
consumption into a Marketplace VM plan. 

When publishing the image, make sure that the Shared Image Gallery is under the same AAD tenant used to
authenticate users for the related Partner Center account. When selecting an image, the Partner Center 
UI only has access to subscriptions associated with that one tenant ID. 


# Getting started

Required software:

* [Packer](https://www.packer.io/downloads): Used to create the Virtual Machines.

* [Terraform](https://www.terraform.io/downloads.html): Used for setting up any VM test environments.

Both software packages should be available on your path. On Linux systems, place packer and terraform into the /usr/bin
folder. On Windows Systems, make sure your path variable is updated to point to the location(s) where you
placed Packer and Terraform. Since these both run as standalone executables, you can place both files
into the same directory.


## Variables and setup

The scripts load their variables from a file called variables.conf. Under bash, this file can be run as a shell
script to introduce the values as bash accessible variables. All the .sh files take advantage of this fact.

For running the same scripts on Windows, variables.conf is sent to a dictionary for use by PowerShell scripts. 


## Building images

There are two folders:

* [Linux](./linux): Contains scripts to demonstrate how to build a common Linux image. While Ubuntu is used here,
the script can be modified to pick a different flavor of Linux: Suse, RedHat, CentOS, Debian, etc. 

* [Windows](./windows): Contains script to demonstrate how to build a common Windows image. This example demonstrates 
how to use Windows Server 2019. The same script should work when configuring other versions of Windows as well. 


Each folder contains:

* Instructions on how to update the SKU used for the base image.

* Assets to validate the image.


## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft 
trademarks or logos is subject to and must follow 
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.
