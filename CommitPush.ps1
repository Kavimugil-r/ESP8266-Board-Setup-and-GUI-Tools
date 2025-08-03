Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Git Commit & Push"
$form.Size = New-Object System.Drawing.Size(400,200)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(245, 245, 255) # Light blueish-white

# Label
$label = New-Object System.Windows.Forms.Label
$label.Text = "Enter your commit message:"
$label.AutoSize = $true
$label.Location = New-Object System.Drawing.Point(20,20)
$label.Font = New-Object System.Drawing.Font("Segoe UI",10)
$form.Controls.Add($label)

# TextBox
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Size = New-Object System.Drawing.Size(340,20)
$textBox.Location = New-Object System.Drawing.Point(20,50)
$textBox.Font = New-Object System.Drawing.Font("Segoe UI",10)
$form.Controls.Add($textBox)

# OK Button
$okButton = New-Object System.Windows.Forms.Button
$okButton.Text = "Commit & Push"
$okButton.Size = New-Object System.Drawing.Size(120,30)
$okButton.Location = New-Object System.Drawing.Point(80,100)
$okButton.BackColor = [System.Drawing.Color]::FromArgb(204, 255, 204) # Light green
$okButton.Font = New-Object System.Drawing.Font("Segoe UI",9,[System.Drawing.FontStyle]::Bold)
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

# Cancel Button
$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Text = "Cancel"
$cancelButton.Size = New-Object System.Drawing.Size(100,30)
$cancelButton.Location = New-Object System.Drawing.Point(220,100)
$cancelButton.BackColor = [System.Drawing.Color]::FromArgb(255, 204, 204) # Light red
$cancelButton.Font = New-Object System.Drawing.Font("Segoe UI",9)
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

# Show dialog
$dialogResult = $form.ShowDialog()

# Handle input
if ($dialogResult -eq [System.Windows.Forms.DialogResult]::OK) {
    $commitMessage = $textBox.Text.Trim()

    if ($commitMessage -eq "") {
        [System.Windows.Forms.MessageBox]::Show("Commit message cannot be empty.","Empty Message",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Warning)
        exit
    }

    git add .

    try {
        git commit -m "$commitMessage"
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Nothing to commit or an error occurred.","Commit Failed",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Error)
        exit
    }

    try {
        git push
        [System.Windows.Forms.MessageBox]::Show(" Push successful!","Done",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Information)
    } catch {
        [System.Windows.Forms.MessageBox]::Show(" Push failed! Check your remote or login.","Push Failed",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Error)
    }
}
