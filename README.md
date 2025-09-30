<img width="230" height="50" alt="Command Center" src="https://github.com/user-attachments/assets/0f24a8aa-16c3-44e7-abd6-0744f91d9346" />

## Don't let AI slop ruin your codebase

Website [cc.dev](https://www.cc.dev/)

### What is this?

CommandCenter is an app intended to make you far more productive at wielding AI coding agents, beginning with solving what for many is the largest bottleneck: understanding the code that it has written.



https://github.com/user-attachments/assets/32969258-78f5-4479-b048-bb38e7e1448f



# Getting started

### 0. Start the service

1. Download the latest (release)[https://github.com/up-to-speed/command-center/releases] for you OS (Mac, Linux, Windows)
2. Then start it via the terminal by doing 

```bash
./command-center-<dist>
```

or double clicking on it via a GUI

**You probably will run into issues with the binary not beeing signed (yet)**

- macOS:
    
    ```bash
    chmod +x ./command-center-macos-*
    xattr -dr com.apple.quarantine ./command-center-macos-*
    
    ```
    
    (right-click → Open also works once.)
    
- Windows: warn SmartScreen → “More info” → “Run anyway”.
- Linux: `chmod +x` and run.
1. visit http://localhost:9000/

### 1. Fix API keys

- Go to ‘**settings**’

<img width="2972" height="1302" alt="image" src="https://github.com/user-attachments/assets/bad4f3b5-da41-43cc-a681-d499c410cc8a" />


- Fill in at least OpenAi

<img width="2892" height="1554" alt="image" src="https://github.com/user-attachments/assets/7f979f01-4957-46b6-8963-2cdf9539583b" />


### Known quirks

- **The walkthroughs are not guaranteed to show all changes**. This is our biggest issue. Working on it.
    - There is also a “Side by Side” view showing you the raw diff — this should compensate. Report any issues you have using that.
- Sometimes entire files are randomly missing from the diff, including the in the raw “Side by Side” diff view.
- The list of already-created walkthroughs only appears when Autorun is on
- When you use the Create Walkthrough button, the results will not show up in the list of walkthroughs
- We’ve sometimes seen walkthroughs fail to generate. To trigger it again, just ask any question to Claude Code, e.g.: “What is 1+1?”
