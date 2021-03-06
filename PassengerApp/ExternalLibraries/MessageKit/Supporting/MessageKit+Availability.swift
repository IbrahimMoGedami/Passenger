/*
 MIT License
 
 Copyright (c) 2017-2019 MessageKit
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import Foundation

public extension MessagesLayoutDelegate {

    func avatarSize(for message:MessageTypes, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        fatalError("avatarSize(for:at:in) has been removed in MessageKit 1.0.")
    }

    func avatarPosition(for message:MessageTypes, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> AvatarPosition {
        fatalError("avatarPosition(for:at:in) has been removed in MessageKit 1.0.")
    }

    func messageLabelInset(for message:MessageTypes, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIEdgeInsets {
        fatalError("messageLabelInset(for:at:in) has been removed in MessageKit 1.0")
    }

    func messagePadding(for message:MessageTypes, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIEdgeInsets {
        fatalError("messagePadding(for:at:in) has been removed in MessageKit 1.0.")
    }

    func cellTopLabelAlignment(for message:MessageTypes, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment {
        fatalError("cellTopLabelAlignment(for:at:in) has been removed in MessageKit 1.0.")
    }

    func cellBottomLabelAlignment(for message:MessageTypes, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment {
        fatalError("cellBottomLabelAlignment(for:at:in) has been removed in MessageKit 1.0.")
    }

    func widthForMedia(message:MessageTypes, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        fatalError("widthForMedia(message:at:with:in) has been removed in MessageKit 1.0.")
    }

    func heightForMedia(message:MessageTypes, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        fatalError("heightForMedia(message:at:with:in) has been removed in MessageKit 1.0.")
    }

    func widthForLocation(message:MessageTypes, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        fatalError("widthForLocation(message:at:with:in) has been removed in MessageKit 1.0.")
    }

   func heightForLocation(message:MessageTypes, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        fatalError("heightForLocation(message:at:with:in) has been removed in MessageKit 1.0.")
    }

    func shouldCacheLayoutAttributes(for message:MessageTypes) -> Bool {
        fatalError("shouldCacheLayoutAttributes(for:) has been removed in MessageKit 1.0.")
    }
}
