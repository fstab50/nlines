<a name="top"></a>
* * *
# nlines
* * *

## Summary

Count the number of lines of text in a code project (or anything else)

**Version**:	1.0.1

* * *
## Contents

* [**DEPENDENCIES**](#dependencies)

* [**SUPPORTED LINUX DISTRIBUTIONS**](#supported-linux-distributions)

* [**INSTALLATION**](#installation)
    * [Ubuntu, Linux Mint, Debian-based Distributions](#installation)
    * [Redhat, CentOS, Fedora, Amazon Linux](#redhat-distro-install)    

* [**USAGE**](#help)

* [**EXCLUSIONS**](#exclusions)

* [**SCREENSHOTS**](#screenshots)

* [**AUTHOR & COPYRIGHT**](#author--copyright)

* [**LICENSE**](#license)

* [**DISCLAIMER**](#disclaimer)

--

[back to the top](#top)

* * *

## Dependencies

[nlines](https://github.com/fstab50/nlines) requires bash v4.4+

--

[back to the top](#top)

* * *
## Supported Linux Distributions

* Ubuntu 16.04, Ubuntu 18.04  
* Linux Mint 18, 19
* Debian variants of Ubuntu / Linux Mint distributions above
* Redhat 7+, CentOS 7+  


--

[back to the top](#top)

* * *
## Installation
* * *

### Ubuntu, Linux Mint, Debian variants

The easiest way to install **nlines** is via the Debian-tools repository:

1. Download the public key:  

    ```
    $ wget -qO - http://awscloud.center/keys/public.key | sudo apt-key add -
    ```

2. Install the repository:

    ```
    $ sudo echo "deb [arch=amd64] http://deb.awscloud.center <distribution> main" > \
                 /etc/apt/sources.list.d/debian-tools.list
    ```

    **Where:** `<distribution>` is one of the following:

    - `trusty`:  Ubuntu 14.04, Ubuntu 14.04 based Linux distributions
    - `xenial`:  Ubuntu 16.04, 16.04 based Linux distributions
    - `bionic`:  Ubuntu 18.04, 18.04 based Linux distributions ([Linux Mint 19](https://www.linuxmint.com/download.php), etc)
    - `cosmic`:  Ubuntu 18.10, 18.10 based Linux distributions

3. Verify **debian-tools** repository installation

    ```
    $  grep ^ /etc/apt/sources.list /etc/apt/sources.list.d/*
    ```

    [![repository-contents](./assets/repo-install-verify.png)](https://s3.us-east-2.amazonaws.com/http-imagestore/nlines/repo-install-verify.png)

4. Update and install the package:

    ```
    $ sudo apt update  &&  sudo apt install nlines
    ```

5. Verify Installation.  To verify a Debian (.deb) package installation:

    ```
    $ apt show nlines
    ```

    ![apt](./assets/apt-show.png)

--

[back to the top](#top)


* * *
<a name="redhat-distro-install"></a>
### Redhat, CentOS, Fedora, Amazon Linux
The easiest way to install **nlines** on redhat-based Linux distributions is via the [developer-tools](http://awscloud.center) package repository:

1. Download and install the repo definition file

    ```
    $ sudo yum install wget
    ```

    [![rpm-install1](./assets/rpm-install-1.png)](https://raw.githubusercontent.com/fstab50/nlines/master/assets/rpm-install-1.png)

    ```
    $ wget http://awscloud.center.s3-website.us-east-2.amazonaws.com/rpm/developer-tools.repo
    ```

    ```
    $ sudo mv developer-tools.repo /etc/yum.repos.d/  &&  sudo chown 0:0 developer-tools.repo
    ```

2. Update local repository cache

    ```
    $ sudo yum update -y
    ```

3. Install **branchdiff** os package

    ```
    $ sudo yum install nlines
    ```

    [![rpm-install2](./assets/rpm-install-2.png)](https://raw.githubusercontent.com/fstab50/nlines/master/assets/rpm-install-2.png)


    Answer "y":

    [![rpm-install3](./assets/rpm-install-3.png)](https://raw.githubusercontent.com/fstab50/nlines/master/assets/rpm-install-3.png)


4. Verify Installation

    ```
    $ yum info nlines
    ```

    [![rpm-install4](./assets/rpm-install-4.png)](https://raw.githubusercontent.com/fstab50/nlines/master/assets/rpm-install-4.png)

[back to the top](#top)


* * *
## Help

To display the help menu:

```bash
    $ nlines --help
```

[![help](./assets/help-menu.png)](https://s3.us-east-2.amazonaws.com/http-imagestore/nlines/help-menu.png)


[back to the top](#top)

* * *
## Exclusions

[nlines](https://github.com/fstab50/nlines) persists a list of excluded file types on the local filesystem.  To see this list, type the following:

```bash
    $ nlines --exclusions
```

![help](https://s3.us-east-2.amazonaws.com/http-imagestore/nlines/exclusions.png)<!-- .element height="50%" width="50%" -->


[back to the top](#top)

* * *
## Screenshots

Counting lines in large repository with long paths.

```bash
    $ nlines  --sum  git/AWSAMPLES/aws-serverless-workshops/
```

![repo1-1](https://s3.us-east-2.amazonaws.com/http-imagestore/nlines/repofinal.png)


[back to the top](#top)

* * *

## Author & Copyright

All works contained herein copyrighted via below author unless work is explicitly noted by an alternate author.

* Copyright Blake Huber, All Rights Reserved.

[back to the top](#top)

* * *

## License

* Software contained in this repo is licensed under the [license agreement](./LICENSE.md).

[back to the top](#top)

* * *

## Disclaimer

*Code is provided "as is". No liability is assumed by either the code's originating author nor this repo's owner for their use at AWS or any other facility. Furthermore, running function code at AWS may incur monetary charges; in some cases, charges may be substantial. Charges are the sole responsibility of the account holder executing code obtained from this library.*

Additional terms may be found in the complete [license agreement](./LICENSE.md).

[back to the top](#top)

* * *
