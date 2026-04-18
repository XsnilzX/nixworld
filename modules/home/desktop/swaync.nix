{
  services.swaync = {
    enable = true;
    settings = {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      control-center-margin-top = 50;
      notification-outer-margin = 10;
      notification-margin-left = 16;
      notification-margin-right = 16;
      notification-outer-padding = 8;
      notification-corner-radius = 20;
      notification-font = "JetBrainsMono Nerd Font 13";
      notification-background = "#2b2b3bcc";
      notification-foreground = "#cdd6f4";
      notification-border-color = "#585b70cc";
      notification-border-size = 2;
      notification-icon-size = 48;
      notification-default-timeout = 5000;
      timeout-low = 10000;
      timeout-critical = 0;
      notification-critical-background = "#eb937dcc";
      notification-critical-foreground = "#ffffff";
      notification-critical-border-color = "#ff0000cc";
      enable-transparency = true;
      transparency = 0.8;
      width-percentage = 35;
      control-center-width-percentage = 40;
      control-center-height-percentage = 60;
      image-visibility = true;
      control-center-corner-radius = 20;
      transition-time = 200;
      hide-on-clear = false;
    };
    style = ''
      .notification {
          border-radius: 20px;
          background: rgba(43,43,59,0.85);
          color: #cdd6f4;
          border: 2px solid #585b70cc;
          font-family: "JetBrainsMono Nerd Font", monospace;
          font-size: 13px;
          padding: 8px 16px;
          margin: 10px 0;
          box-shadow: 0 8px 32px 0 rgba(0,0,0,0.20);
          backdrop-filter: blur(6px);
          transition: box-shadow 0.2s, background 0.2s;
      }

      .notification.low {
          background: rgba(30,30,46,0.85);
          color: #cdd6f4;
          border-color: #585b70cc;
      }

      .notification.normal {
          background: rgba(43,43,59,0.85);
          color: #cdd6f4;
          border-color: #585b70cc;
      }

      .notification.critical {
          background: rgba(235,147,125,0.85);
          color: #ffffff;
          border-color: #ff0000cc;
          box-shadow: 0 0 20px 0 #ff000055;
      }

      .notification .icon {
          width: 48px;
          height: 48px;
          margin-right: 8px;
          border-radius: 12px;
      }

      .notification .title {
          font-weight: bold;
          font-size: 14px;
          margin-bottom: 4px;
      }

      .notification .progress {
          border-radius: 8px;
          height: 6px;
          margin-top: 6px;
          background: #585b7033;
      }

      .notification .progress-bar {
          background: linear-gradient(90deg, #89b4fa, #f38ba8);
          border-radius: 8px;
      }

      .notification .button {
          border-radius: 12px;
          background: #585b70cc;
          color: #cdd6f4;
          padding: 4px 14px;
          font-size: 13px;
          border: none;
          margin: 4px 6px 0 0;
          transition: background 0.2s;
      }

      .notification .button:hover {
          background: #a6adc8cc;
          color: #1e1e2e;
      }

      .notification .close {
          background: transparent;
          color: #a6adc8;
          font-size: 16px;
          border: none;
          margin-left: 4px;
          cursor: pointer;
          transition: color 0.2s;
      }

      .notification .close:hover {
          color: #ff0000cc;
      }

      .control-center {
          border-radius: 20px;
          background: rgba(43,43,59,0.85);
          color: #cdd6f4;
          font-family: "JetBrainsMono Nerd Font", monospace;
          font-size: 13px;
          box-shadow: 0 12px 48px 0 rgba(0,0,0,0.28);
          padding: 16px;
          backdrop-filter: blur(8px);
      }

      .history-list .history-item {
          border-radius: 16px;
          background: rgba(30,30,46,0.70);
          margin: 8px 0;
          padding: 8px 12px;
          transition: background 0.2s;
      }

      .history-list .history-item:hover {
          background: rgba(205,214,244,0.13);
      }

      ::-webkit-scrollbar {
          width: 8px;
      }

      ::-webkit-scrollbar-thumb {
          background: #585b7033;
          border-radius: 8px;
      }

      .notification,
      .control-center {
          backdrop-filter: blur(8px);
          -webkit-backdrop-filter: blur(8px);
      }
    '';
  };
}
