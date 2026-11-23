#!/usr/bin/env python3
"""
Generate Studio-Grade Microsoft Neural Audio (24kHz HD) for Nexus English seed packs.
Uses edge-tts with natural human neural voices:
- en-US-JennyNeural
- en-US-GuyNeural
- en-US-ChristopherNeural
- en-GB-SoniaNeural
"""

import asyncio
import json
import os
import sys

# Ensure user python packages are found
sys.path.insert(0, os.path.expanduser("~/Library/Python/3.9/lib/python/site-packages"))

import edge_tts

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ASSETS_DIR = os.path.join(ROOT, "assets")
SEED_DIR = os.path.join(ASSETS_DIR, "seed")
AUDIO_DIR = os.path.join(ASSETS_DIR, "audio")

VOICE_FEMALE_US = "en-US-JennyNeural"
VOICE_MALE_US = "en-US-GuyNeural"
VOICE_NARRATOR = "en-US-ChristopherNeural"
VOICE_FEMALE_UK = "en-GB-SoniaNeural"
VOICE_MALE_UK = "en-GB-RyanNeural"

FORCE_OVERWRITE = "--force" in sys.argv or "-f" in sys.argv

async def generate_file(text: str, voice: str, output_path: str, force: bool = False):
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    if not force and not FORCE_OVERWRITE and os.path.exists(output_path) and os.path.getsize(output_path) > 500:
        return
    try:
        communicate = edge_tts.Communicate(text, voice)
        await communicate.save(output_path)
        print(f"✓ Generated: {os.path.basename(output_path)} [{voice}] -> '{text[:30]}...'")
    except Exception as e:
        print(f"Error generating {output_path}: {e}")

async def main():
    print("🎙 Generating Studio Neural Audio (Microsoft Neural 24kHz HD)...")

    # 1. Dialogues
    dlg_path = os.path.join(SEED_DIR, "dialogues_seed.json")
    if os.path.exists(dlg_path):
        with open(dlg_path, "r", encoding="utf-8") as f:
            dialogues = json.load(f)
        for d in dialogues:
            node_id = d["id"]
            text = d["lineEnglish"]
            speaker = d.get("characterName", "")
            if "Arthur" in speaker:
                voice = VOICE_MALE_UK
            elif "🇬🇧" in speaker or "Emma" in speaker:
                voice = VOICE_FEMALE_UK
            elif "Jenny" in speaker or "Sarah" in speaker:
                voice = VOICE_FEMALE_US
            elif "Mike" in speaker:
                voice = VOICE_MALE_US
            else:
                voice = VOICE_MALE_US
            out_file = os.path.join(AUDIO_DIR, "dialogue", f"{node_id}.mp3")
            await generate_file(text, voice, out_file, force=True)
            d["audioPath"] = f"assets/audio/dialogue/{node_id}.mp3"

            for opt in d.get("options", []):
                opt_id = opt["id"]
                opt_text = opt["labelEnglish"]
                opt_file = os.path.join(AUDIO_DIR, "dialogue", f"{opt_id}.mp3")
                opt_voice = VOICE_NARRATOR if "Arthur" in speaker else (VOICE_MALE_UK if ("🇬🇧" in speaker or "Emma" in speaker) else VOICE_NARRATOR)
                await generate_file(opt_text, opt_voice, opt_file, force=True)
                opt["audioPath"] = f"assets/audio/dialogue/{opt_id}.mp3"

        with open(dlg_path, "w", encoding="utf-8") as f:
            json.dump(dialogues, f, ensure_ascii=False, indent=2)

    # 2. Listening exercises & Minimal pairs
    list_path = os.path.join(SEED_DIR, "listening_seed.json")
    if os.path.exists(list_path):
        with open(list_path, "r", encoding="utf-8") as f:
            listening = json.load(f)
        for item in listening:
            item_id = item["id"]
            text = item["transcript"]
            out_file = os.path.join(AUDIO_DIR, "listening", f"{item_id}.mp3")
            await generate_file(text, VOICE_NARRATOR, out_file)
            item["audioUrl"] = f"assets/audio/listening/{item_id}.mp3"

        with open(list_path, "w", encoding="utf-8") as f:
            json.dump(listening, f, ensure_ascii=False, indent=2)

    # 3. Dictionary entries
    dict_path = os.path.join(SEED_DIR, "dictionary_seed.json")
    if os.path.exists(dict_path):
        with open(dict_path, "r", encoding="utf-8") as f:
            words = json.load(f)
        for w in words:
            word_id = w["id"]
            text = w["word"]
            out_file = os.path.join(AUDIO_DIR, "dictionary", f"{word_id}.mp3")
            await generate_file(text, VOICE_FEMALE_US, out_file)
            w["audioUrl"] = f"assets/audio/dictionary/{word_id}.mp3"

        with open(dict_path, "w", encoding="utf-8") as f:
            json.dump(words, f, ensure_ascii=False, indent=2)

    # 3.5 Word of the Day and Dictionary Extras
    wotd_items = [
        ("dict_perseverance", "perseverance", VOICE_FEMALE_US),
        ("dict_friendship", "friendship", VOICE_FEMALE_US),
        ("wotd_perseverance_example", "Success comes through steady perseverance.", VOICE_NARRATOR),
        ("wotd_opportunity_example", "Every challenge is an opportunity to grow.", VOICE_NARRATOR),
        ("wotd_journey_example", "A journey of a thousand miles begins with a single step.", VOICE_NARRATOR),
        ("wotd_friendship_example", "True friendship is a rare treasure.", VOICE_NARRATOR),
    ]
    for item_id, text, voice in wotd_items:
        out_file = os.path.join(AUDIO_DIR, "dictionary", f"{item_id}.mp3")
        await generate_file(text, voice, out_file, force=True)

    # 4. Slang & Idioms
    slang_path = os.path.join(SEED_DIR, "slang_seed.json")
    if os.path.exists(slang_path):
        with open(slang_path, "r", encoding="utf-8") as f:
            slang_items = json.load(f)
        for s in slang_items:
            item_id = s["id"]
            text = s["expression"]
            out_file = os.path.join(AUDIO_DIR, "slang", f"{item_id}.mp3")
            await generate_file(text, VOICE_NARRATOR, out_file, force=True)
            s["audioUrl"] = f"assets/audio/slang/{item_id}.mp3"

        with open(slang_path, "w", encoding="utf-8") as f:
            json.dump(slang_items, f, ensure_ascii=False, indent=2)

    # 5. Shadowing Phrases
    sh_path = os.path.join(SEED_DIR, "shadowing_seed.json")
    if os.path.exists(sh_path):
        with open(sh_path, "r", encoding="utf-8") as f:
            sh_items = json.load(f)
        for sh in sh_items:
            item_id = sh["id"]
            text = sh["textEnglish"]
            out_file = os.path.join(AUDIO_DIR, "shadowing", f"{item_id}.mp3")
            await generate_file(text, VOICE_FEMALE_US if "sh_cafe" in item_id or "sh_weather" in item_id else VOICE_MALE_US, out_file, force=True)
            sh["audioPath"] = f"assets/audio/shadowing/{item_id}.mp3"

        with open(sh_path, "w", encoding="utf-8") as f:
            json.dump(sh_items, f, ensure_ascii=False, indent=2)

    print("\n✅ All neural audio tracks generated and verified successfully!")

if __name__ == "__main__":
    asyncio.run(main())
