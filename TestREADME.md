<!-- CHAPTER START -->
# Let's Talk about Strings
Lets convert lowercase strings to uppercase

```ps
'this Is MixEd CaSe'.ToUpper()
```

## Prints

```
THIS IS MIXED CASE
```

<!-- CHAPTER END -->

<!-- CHAPTER START -->
# Let's Talk about Functions
Here is a simple function.

```ps
function test {
    "Hello World"
}
```

### Example Usage

```powershell
PS C:\> test

Hello World
```

<!-- CHAPTER END -->

<!-- CHAPTER START -->
# Let's Talk about ScriptAnalyzer Errors

Spot the issue


```ps
function test {
    param($p)

    $result = "Hello $p"
}
```

### Example Usage

```powershell
PS C:\> test
```

<!-- CHAPTER END -->