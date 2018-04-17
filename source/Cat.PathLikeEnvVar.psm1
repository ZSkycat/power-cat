class PathLikeEnvVar {
    [string]$name
    [System.EnvironmentVariableTarget]$target
    [Collections.Generic.List[String]]$data

    PathLikeEnvVar ([System.EnvironmentVariableTarget]$target) {
        $this.Constructor($target, 'Path')
    }
    PathLikeEnvVar ([System.EnvironmentVariableTarget]$target, [string]$name) {
        $this.Constructor($target, $name)
    }

    hidden [void] Constructor([System.EnvironmentVariableTarget]$target, [string]$name) {
        $this.name = $name
        $this.target = $target
        $this.data = [System.Environment]::GetEnvironmentVariable($name, $target).Split(';', [System.StringSplitOptions]::RemoveEmptyEntries)
    }

    [bool]Set([string]$value) {
        if ($this.data.Exists({ param($_) $this.IsEqual($_, $value)})) {
            return $false
        }
        else {
            $this.data.Add($value)
            return $true
        }
    }

    [bool]Remove([string]$value) {
        $item = $this.data.Find( { param($x) $this.IsEqual($x, $value)})
        if ($item -eq $null) {
            return $false
        }
        else {
            return $this.data.Remove($item)
        }
    }

    [bool]Save() {
        $value = [string]::Join(';', $this.data) + ';'
        [System.Environment]::SetEnvironmentVariable($this.name, $value, $this.target)
        return $true
    }

    hidden [bool] IsEqual([string]$path1, [string]$path2) {
        $path1 = $path1.TrimEnd('\')
        $path2 = $path2.TrimEnd('\')
        return $path1 -eq $path2
    }
}
