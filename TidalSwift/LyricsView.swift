//
//  LyricsView.swift
//  TidalSwift
//
//  Created by Melvin Gundlach on 07.10.19.
//  Copyright © 2019 Melvin Gundlach. All rights reserved.
//

import SwiftUI
import Combine
import TidalSwiftLib

struct LyricsView: View {
	let lyricsHandler = Lyrics()
	
	@EnvironmentObject var queueInfo: QueueInfo
	
	@State var currentIndexCancellable: AnyCancellable?
	@State var queueCancellable: AnyCancellable?
	
	@State var workItem: DispatchWorkItem?
	@State var loadingState: LoadingState = .loading
	
	@State var lyrics: String?
	@State var lastTrack: Track?
	var track: Track? {
		if !queueInfo.queue.isEmpty {
			return queueInfo.queue[queueInfo.currentIndex].track
		} else {
			return nil
		}
	}
	
	var body: some View {
		ScrollView {
			VStack(alignment: .leading) {
				if track != nil {
					HStack {
						Text(track!.title)
							.font(.title)
							.padding(.bottom)
						Spacer(minLength: 0)
					}
					Text(track!.artists.formArtistString())
						.font(.headline)
						.padding(.bottom)
					if loadingState == .successful {
						Text(lyrics!)
							.contextMenu {
								Button(action: {
									print("Copy Lyrics")
									Pasteboard.copy(string: self.lyrics!)
								}) {
									Text("Copy")
								}
							}
					} else if loadingState == .loading {
						FullscreenLoadingSpinner(.loading)
					} else {
						Text("No Lyrics available")
							.foregroundColor(.secondary)
					}
				} else {
					HStack {
						Text("No track")
							.font(.title)
							.padding(.bottom)
						Spacer(minLength: 0)
					}
				}
				Spacer(minLength: 0)
			}
			.padding()
		}
		.onAppear {
			self.currentIndexCancellable = self.queueInfo.$currentIndex.receive(on: DispatchQueue.main).sink(receiveValue: { _ in self.fetchLyrics() })
			self.queueCancellable = self.queueInfo.$queue.receive(on: DispatchQueue.main).sink(receiveValue: { _ in self.fetchLyrics() })
			self.fetchLyrics()
		}
		.onDisappear {
			self.workItem?.cancel()
			self.currentIndexCancellable?.cancel()
			self.queueCancellable?.cancel()
		}
	}
	
	func fetchLyrics() {
		print("Lyrics Fetch for \(track?.title ?? "nil")")
		if track == lastTrack {
			print("Lyrics: Same as lastTrack")
			return
		}
		lastTrack = track
		workItem?.cancel()
		loadingState = .loading
		workItem = createWorkItem()
		if workItem != nil {
			DispatchQueue.global(qos: .userInitiated).async(execute: workItem!)
		}
		
	}
	
	func createWorkItem() -> DispatchWorkItem {
		DispatchWorkItem {
			guard let track = self.track else {
				DispatchQueue.main.async {
					self.loadingState = .error
				}
				return
			}
			let t = self.lyricsHandler.getLyrics(for: track)
			DispatchQueue.main.async {
				if t != nil {
					self.lyrics = t
					self.loadingState = .successful
				} else {
					self.loadingState = .error
				}
			}
		}
	}
}
