import { ReactNode, useEffect, useState } from 'react';

interface PageTransitionProps {
  pageKey: string;
  children: ReactNode;
}

export default function PageTransition({ pageKey, children }: PageTransitionProps) {
  const [displayedKey, setDisplayedKey] = useState(pageKey);
  const [displayedChildren, setDisplayedChildren] = useState(children);
  const [visible, setVisible] = useState(true);

  useEffect(() => {
    if (pageKey === displayedKey) {
      setDisplayedChildren(children);
      return;
    }

    setVisible(false);
    const swap = setTimeout(() => {
      setDisplayedKey(pageKey);
      setDisplayedChildren(children);
      setVisible(true);
    }, 150);

    return () => clearTimeout(swap);
  }, [pageKey, children, displayedKey]);

  return (
    <div
      className={`transition-all duration-150 ease-in-out ${
        visible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-1'
      }`}
    >
      {displayedChildren}
    </div>
  );
}
