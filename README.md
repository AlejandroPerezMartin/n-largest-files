N-Largest-Files
===============

**KSH Script that finds the N largest files in the given folders.**

- To execute this script you must change file permissions by typing this in your console:

```shell
sudo chmod 777 n_largest_files.sh
```

You can give other permissions (766, 644, etc).

- After that, let's execute the script by typing this:

```shell
n_largest_files.sh
```

This will show the 10 largest files contained in current directory.


- To show as much files as you want, execute this command:

```shell
n_largest_files.sh -NUMBER  # Where NUMBER is any number greater than 0
```

Example:

```shell
n_largest_files.sh -7
```

- To find the largest files contained in a directory (or more than one):

```shell
n_largest_files.sh -5 folder1 .. folderN
```

- There are more options such as show results in 'Human readable numbers', Bytes, Kilobytes and Megabytes, or sort in order.
To make use of this, run this command:

```shell
n_largest_files.sh -3 -X folder1 .. folderN # Where X should be replaced with (h:human, b:bytes, k:KB, m:MB, s:sort)
```
