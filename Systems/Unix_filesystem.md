# Unix filesystem

[Wikipedia](https://en.wikipedia.org/wiki/Unix_filesystem)

## Principles

The filesystem appears as one rooted tree of directories. Instead of addressing separate volumes such as disk partitions, removable media, and network shares as separate trees, such volumes can be mounted on a directory, causing the volume's file system tree to appear as that directory in the larger tree. The root of the entire tree is denoted /.

Unix directories do not contain files. Instead, they contain the names of files paired with references to so-called inodes, which in turn contain both the file and its metadata (owner, permissions, time of last access, etc., but no name).

Multiple names in the file system may refer to the same file, a feature termed a hard link.

## [inode](https://en.wikipedia.org/wiki/Inode)

The inode (index node) is a data structure that describes a file-system object such as a file or a directory. Each inode stores the attributes and disk block locations of the object's data. File-system object attributes may include metadata (times of last change, access, modification), as well as owner and permission data.

A directory is a list of inodes with their assigned names. The list includes an entry for itself, its parent, and each of its children.

A file system relies on data structures about the files, as opposed to the contents of that file.

## Links

### [Hard link](https://en.wikipedia.org/wiki/Hard_link)

A hard link is a directory entry (in a directory-based file system) that associates a name with a file. Thus, each file must have at least one hard link.

Creating additional hard links for a file makes the contents of that file accessible via additional paths (i.e., via different names or in different directories).

From a users point of view this is ONE file with several filenames. Editing any filename modifies "all" files, however deleting "any" filename except the last one keeps the file around.

By contrast, a soft link or “shortcut” to a file is not a direct link to the data itself, but rather a reference to a hard link or another soft link.

### [Symbolic link](https://en.wikipedia.org/wiki/Symbolic_link)

A symbolic link contains a text string that is automatically interpreted and followed by the operating system as a path to another file or directory.

This other file or directory is called the "target". The symbolic link is a second file that exists independently of its target. If a symbolic link is deleted, its target remains unaffected.

## File types

Ordinary files, directories, "special files", also termed device files; symlinks.
