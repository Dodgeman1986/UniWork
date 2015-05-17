namespace TextProcessing
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.txtFilePath = new System.Windows.Forms.TextBox();
            this.btnFindFile = new System.Windows.Forms.Button();
            this.rtDisplayArea = new System.Windows.Forms.RichTextBox();
            this.txtTransitionWords = new System.Windows.Forms.TextBox();
            this.btnTransition = new System.Windows.Forms.Button();
            this.btnProcess = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // txtFilePath
            // 
            this.txtFilePath.Enabled = false;
            this.txtFilePath.Location = new System.Drawing.Point(13, 13);
            this.txtFilePath.Name = "txtFilePath";
            this.txtFilePath.Size = new System.Drawing.Size(279, 20);
            this.txtFilePath.TabIndex = 0;
            // 
            // btnFindFile
            // 
            this.btnFindFile.Location = new System.Drawing.Point(299, 11);
            this.btnFindFile.Name = "btnFindFile";
            this.btnFindFile.Size = new System.Drawing.Size(127, 23);
            this.btnFindFile.TabIndex = 1;
            this.btnFindFile.Text = "File to Process";
            this.btnFindFile.UseVisualStyleBackColor = true;
            this.btnFindFile.Click += new System.EventHandler(this.btnFindFile_Click);
            // 
            // rtDisplayArea
            // 
            this.rtDisplayArea.Location = new System.Drawing.Point(13, 97);
            this.rtDisplayArea.Name = "rtDisplayArea";
            this.rtDisplayArea.Size = new System.Drawing.Size(413, 181);
            this.rtDisplayArea.TabIndex = 3;
            this.rtDisplayArea.Text = "";
            // 
            // txtTransitionWords
            // 
            this.txtTransitionWords.Enabled = false;
            this.txtTransitionWords.Location = new System.Drawing.Point(13, 40);
            this.txtTransitionWords.Name = "txtTransitionWords";
            this.txtTransitionWords.Size = new System.Drawing.Size(279, 20);
            this.txtTransitionWords.TabIndex = 4;
            // 
            // btnTransition
            // 
            this.btnTransition.Location = new System.Drawing.Point(299, 38);
            this.btnTransition.Name = "btnTransition";
            this.btnTransition.Size = new System.Drawing.Size(127, 23);
            this.btnTransition.TabIndex = 5;
            this.btnTransition.Text = "Transition Word File";
            this.btnTransition.UseVisualStyleBackColor = true;
            this.btnTransition.Click += new System.EventHandler(this.btnTransition_Click);
            // 
            // btnProcess
            // 
            this.btnProcess.Location = new System.Drawing.Point(299, 68);
            this.btnProcess.Name = "btnProcess";
            this.btnProcess.Size = new System.Drawing.Size(127, 23);
            this.btnProcess.TabIndex = 6;
            this.btnProcess.Text = "Process";
            this.btnProcess.UseVisualStyleBackColor = true;
            this.btnProcess.Click += new System.EventHandler(this.btnProcess_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(438, 290);
            this.Controls.Add(this.btnProcess);
            this.Controls.Add(this.btnTransition);
            this.Controls.Add(this.txtTransitionWords);
            this.Controls.Add(this.rtDisplayArea);
            this.Controls.Add(this.btnFindFile);
            this.Controls.Add(this.txtFilePath);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.Name = "Form1";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Text Processing";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox txtFilePath;
        private System.Windows.Forms.Button btnFindFile;
        private System.Windows.Forms.RichTextBox rtDisplayArea;
        private System.Windows.Forms.TextBox txtTransitionWords;
        private System.Windows.Forms.Button btnTransition;
        private System.Windows.Forms.Button btnProcess;
    }
}

