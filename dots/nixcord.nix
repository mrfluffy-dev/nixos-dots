{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.nixcord = {
    enable = true;
    discord = {
      enable = false;
      package = pkgs.vencord;
    };
    vesktop = {
      enable = true;
      package = pkgs.vesktop;
      useSystemVencord = false;
    };
    config = {
      plugins = {
        alwaysTrust = {
          enable = true;
          file = true;
        };
        translate = {
          enable = true;
        };
        anonymiseFileNames = {
          enable = true;
          anonymiseByDefault = true;
        };
        betterRoleContext = {
          enable = true;
        };
        betterRoleDot = {
          enable = true;
        };
        betterUploadButton = {
          enable = true;
        };
        biggerStreamPreview = {
          enable = true;
        };
        clearUrLs = {
          enable = true;
        };
        copyFileContents = {
          enable = true;
        };
        fakeNitro = {
          enable = true;
          enableEmojiBypass = true;
        };
        fixImagesQuality = {
          enable = true;
        };
        fixYoutubeEmbeds = {
          enable = true;
        };
        forceOwnerCrown = {
          enable = true;
        };
        friendsSince = {
          enable = true;
        };
        gifPaste = {
          enable = true;
        };
        imageZoom = {
          enable = true;
        };
        memberCount = {
          enable = true;
        };
        messageLinkEmbeds = {
          enable = true;
        };
        messageLogger = {
          enable = true;
        };
        petpet = {
          enable = true;
        };
        pictureInPicture = {
          enable = true;
        };
        reverseImageSearch = {
          enable = true;
        };
        showHiddenChannels = {
          enable = true;
        };
        showHiddenThings = {
          enable = true;
        };
        showTimeoutDuration = {
          enable = true;
        };
        whoReacted = {
          enable = true;
        };
        youtubeAdblock = {
          enable = true;
        };
      };
    };
  };
}

