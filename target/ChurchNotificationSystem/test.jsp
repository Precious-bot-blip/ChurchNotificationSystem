<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Font Preview - City Church</title>
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Roboto+Mono:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <style>
        body {
            display: block;
            padding: 40px;
            min-height: 100vh;
        }
        .test-container {
            max-width: 800px;
            margin: 0 auto;
        }
        .test-card {
            background: var(--background-card);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 40px;
            margin-bottom: 20px;
        }
        .font-preview {
            margin: 10px 0;
            padding: 10px 0;
            border-bottom: 1px solid var(--border-color);
        }
        .font-preview:last-child {
            border-bottom: none;
        }
        .label {
            color: var(--text-secondary);
            font-size: 14px;
            font-weight: 700;
            margin-bottom: 5px;
        }
    </style>
</head>
<body>
    <div class="test-container">
        <div class="test-card">
            <h2>City Church</h2>
            <h3>Font Preview</h3>
            
            <div class="font-preview">
                <div class="label">Bebas Neue 57px (Title)</div>
                <div style="font-family: 'Bebas Neue', cursive; font-size: 57px; color: var(--primary-color);">
                    City Church
                </div>
            </div>
            
            <div class="font-preview">
                <div class="label">Roboto Mono 28px (Subheading)</div>
                <div style="font-family: 'Roboto Mono', monospace; font-size: 28px; color: var(--text-secondary);">
                    Login &#8226; Register &#8226; Notifications
                </div>
            </div>
            
            <div class="font-preview">
                <div class="label">Roboto Mono 20px (Paragraph)</div>
                <div style="font-family: 'Roboto Mono', monospace; font-size: 20px; color: var(--text-primary);">
                    This is the paragraph text. The quick brown fox jumps over the lazy dog.
                </div>
            </div>
            
            <div class="font-preview">
                <div class="label">Roboto Mono 18px (Form Inputs)</div>
                <input type="text" value="Sample Input Text" style="width:100%; padding:12px 16px; background:var(--background-input); border:1px solid var(--border-color); border-radius:8px; color:var(--text-primary); font-family:'Roboto Mono',monospace; font-size:18px;">
            </div>
            
            <div style="margin-top: 30px; text-align: center;">
                <a href="login.jsp" style="color: var(--primary-color); text-decoration: none; font-size: 20px;">Go to Login</a>
            </div>
        </div>
    </div>
</body>
</html>