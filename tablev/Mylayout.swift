//
//  Mylayout.swift
//  tablev
//
//  Created by CYAX_BOY on 2020/12/13.
//

import UIKit

extension UICollectionViewLayoutAttributes {
    func leftAlignFrameWithSectionInset(sectionInset: UIEdgeInsets) {
        var oframe = self.frame;
        oframe.origin.x = sectionInset.left;
        self.frame = oframe;
    }

}
class Mylayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let originalAttributes:[UICollectionViewLayoutAttributes] = super.layoutAttributesForElements(in: rect) ?? []
        var updatedAttributes = originalAttributes
        for att in originalAttributes {
            if (att.representedElementKind == nil) {
                let index: Int = updatedAttributes.firstIndex(of: att) ?? 0
                updatedAttributes[index] = layoutAttributesForItemAtIndexPath(indexPath: att.indexPath)
            }
        }
        return updatedAttributes
    }
    func layoutAttributesForItemAtIndexPath(indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        let currentItemAttributes = super.layoutAttributesForItem(at: indexPath)
        let sectionInset = evaluatedSectionInsetForItemAtIndex(index: indexPath.section)
        let isFirstItemInSection = indexPath.item == 0
        //算出能显示的最大宽度 collectionView最大宽度-layout的sectionInset
        let layoutWidth: CGFloat = (self.collectionView?.frame.size.width)! - sectionInset.left - sectionInset.right
        if isFirstItemInSection {
            currentItemAttributes?.leftAlignFrameWithSectionInset(sectionInset: sectionInset)
            return currentItemAttributes!
        }
        let previousIndexPath = IndexPath(row: indexPath.item - 1, section: indexPath.section)
        let previousFrame:CGRect = layoutAttributesForItemAtIndexPath(indexPath: previousIndexPath).frame
        let previousFrameRightPoint: CGFloat = previousFrame.origin.x + previousFrame.size.width
        let currentFrame: CGRect = currentItemAttributes!.frame
        let strecthedCurrentFrame: CGRect = CGRect(x: sectionInset.left, y: currentFrame.origin.y, width: layoutWidth, height: currentFrame.size.height)
        
        let isFirstItemInRow:Bool = !previousFrame.intersects(strecthedCurrentFrame)
        if isFirstItemInRow {
            currentItemAttributes?.leftAlignFrameWithSectionInset(sectionInset: sectionInset)
            return currentItemAttributes!
        }
        var frame:CGRect = currentItemAttributes!.frame
        frame.origin.x = previousFrameRightPoint + evaluatedMinimumInteritemSpacingForSectionAtIndex(sectionIndex: indexPath.section)
        currentItemAttributes?.frame = frame
        return currentItemAttributes!
    }
    func evaluatedSectionInsetForItemAtIndex(index: Int) -> UIEdgeInsets {
        return sectionInset
    }
    func evaluatedMinimumInteritemSpacingForSectionAtIndex(sectionIndex: Int) -> CGFloat {
        return minimumInteritemSpacing
    }
}
