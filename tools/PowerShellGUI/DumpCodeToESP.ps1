Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object Windows.Forms.Form
$form.Text = "Dump Code to ESP8266"
$form.Size = New-Object Drawing.Size(400,300)

$label = New-Object Windows.Forms.Label
$label.Text = "Select Folder with main.py:"
$label.Location = New-Object Drawing.Point(10,20)
$label.Size = New-Object Drawing.Size(360,20)

$browseBtn = New-Object Windows.Forms.Button
$browseBtn.Text = "Browse"
$browseBtn.Location = New-Object Drawing.Point(10,50)

$listBox = New-Object Windows.Forms.ListBox
$listBox.Location = New-Object Drawing.Point(10,120)
$listBox.Size = New-Object Drawing.Size(360,100)

$portLabel = New-Object Windows.Forms.Label
$portLabel.Text = "Select COM Port:"
$portLabel.Location = New-Object Drawing.Point(10,90)

$comboPort = New-Object Windows.Forms.ComboBox
$comboPort.Location = New-Object Drawing.Point(120,90)
$comboPort.Items.AddRange([System.IO.Ports.SerialPort]::GetPortNames())
$comboPort.SelectedIndex = 0

$uploadBtn = New-Object Windows.Forms.Button
$uploadBtn.Text = "Upload"
$uploadBtn.Location = New-Object Drawing.Point(10,230)

$folderPath = ""

$browseBtn.Add_Click({
    $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($dialog.ShowDialog() -eq "OK") {
        $folderPath = $dialog.SelectedPath
        $files = Get-ChildItem $folderPath -File | Where-Object { $_.Name -match "\.py$" }
        if (-not ($files.Name -contains "main.py")) {
            [System.Windows.Forms.MessageBox]::Show("main.py is missing!")
        } else {
            $listBox.Items.Clear()
            $files | ForEach-Object { $listBox.Items.Add($_.Name) }
        }
    }
})

$uploadBtn.Add_Click({
    if (-not $folderPath) {
        [System.Windows.Forms.MessageBox]::Show("Select a folder first")
        return
    }
    $port = $comboPort.SelectedItem
    if (-not $port) {
        [System.Windows.Forms.MessageBox]::Show("Select COM port")
        return
    }

    $files = Get-ChildItem $folderPath -File | Where-Object { $_.Name -match "\.py$" }
    foreach ($file in $files) {
        Start-Process "ampy" -ArgumentList "--port $port put `"$($file.FullName)`"" -NoNewWindow -Wait
    }

    [System.Windows.Forms.MessageBox]::Show("Upload completed.")
})

$form.Controls.AddRange(@($label, $browseBtn, $comboPort, $portLabel, $listBox, $uploadBtn))
$form.ShowDialog()
